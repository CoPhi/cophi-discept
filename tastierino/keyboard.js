// keyboard.js — Tastierino DSL Euporia (basso sinistra, 3–4 bottoni per riga, con JSON fallback)
window.addEventListener("load", () => {
  console.log("⌨️ Keyboard.js loaded — versione larga, 3–4 per riga, JSON + fallback");

  const JSON_PATH = "js/keyboard-config.json";
  const LEXER_PATH = "js/euporia/src/EuporiaLexer.g4";
  const EDITOR_URL = "keyboard-editor.html";

  async function initKeyboard() {
    try {
      let categories = null;

      // 🔍 1. tenta di caricare JSON
      try {
        console.log("🔍 Cerco configurazione JSON...");
        const res = await fetch(JSON_PATH);
        if (res.ok) {
          const json = await res.json();
          categories = json.categories || json;
          console.log("✅ Configurazione caricata da JSON");
        } else {
          throw new Error("JSON non trovato");
        }
      } catch (err) {
        console.warn("⚠️ Nessun JSON trovato, uso fallback dal lexer:", err.message);
        categories = await parseFromLexer();
      }

      // 🔘 Pulsante toggle
      const toggleBtn = document.createElement("button");
      toggleBtn.textContent = "⌨️ DSL";
      Object.assign(toggleBtn.style, {
        position: "fixed",
        bottom: "1rem",
        left: "1rem",
        background: "#3b82f6",
        color: "white",
        border: "none",
        borderRadius: "8px",
        padding: "0.7rem 1rem",
        cursor: "pointer",
        fontWeight: "600",
        fontSize: "0.9rem",
        boxShadow: "0 3px 6px rgba(0,0,0,0.2)",
        zIndex: 10001
      });
      document.body.appendChild(toggleBtn);

      // 🔹 Tastierino — largo, basso, scroll verticale
      const kb = document.createElement("div");
      Object.assign(kb.style, {
        position: "fixed",
        bottom: "3.5rem",
        left: "1rem",
        width: "640px",
        maxHeight: "22vh",
        overflowY: "auto",
        overflowX: "hidden",
        background: "rgba(255,255,255,0.98)",
        border: "1px solid #ccc",
        borderRadius: "10px",
        padding: "0.8rem 1rem",
        display: "none",
        boxShadow: "2px 2px 8px rgba(0,0,0,0.15)",
        fontFamily: "system-ui, sans-serif",
        zIndex: 9999
      });
      document.body.appendChild(kb);

      const COLORS = [
        "#fef08a", "#bbf7d0", "#bae6fd", "#fbcfe8",
        "#e9d5ff", "#fde68a", "#fecaca", "#d1fae5"
      ];
      let colorIndex = 0;

      const buttonBaseStyle = {
        display: "inline-block",
        width: "29%",
        margin: "0.3rem 1%",
        padding: "0.45rem 0.5rem",
        fontSize: "0.82rem",
        border: "1px solid #999",
        borderRadius: "6px",
        cursor: "pointer",
        fontWeight: "600",
        textAlign: "center",
        transition: "transform 0.1s ease",
        whiteSpace: "nowrap",
        overflow: "hidden",
        textOverflow: "ellipsis"
      };

      // 🔠 Crea sezioni e bottoni
      for (const [cat, tokens] of Object.entries(categories)) {
        const sectionTitle = document.createElement("div");
        sectionTitle.textContent = cat;
        Object.assign(sectionTitle.style, {
          fontWeight: "700",
          margin: "0.5rem 0 0.3rem 0",
          color: "#333",
          borderBottom: "1px solid #ccc",
          width: "100%"
        });
        kb.appendChild(sectionTitle);

        const color = COLORS[colorIndex++ % COLORS.length];

        tokens.forEach(({ label, symbol, name }) => {
          const b = document.createElement("button");
          b.textContent = label;
          b.title = `${name || label} → ${symbol}`;
          Object.assign(b.style, buttonBaseStyle, { background: color });

          b.onmouseenter = () => (b.style.transform = "scale(1.05)");
          b.onmouseleave = () => (b.style.transform = "scale(1.0)");

          b.onclick = () => {
            const aceDiv = document.querySelector(".ace_editor");
            if (!aceDiv) return alert("Editor Euporia non trovato!");
            const editor = ace.edit(aceDiv.id);
            const text = symbol.replace(/\\n/g, "\n");
            editor.session.insert(editor.getCursorPosition(), text + " ");
            editor.focus();
          };

          kb.appendChild(b);
        });
      }

      // 🔗 Link all’editor tastierino
      const footer = document.createElement("div");
      footer.innerHTML = `
        <div style="text-align:right; margin-top:0.6rem;">
          <a href="${EDITOR_URL}" target="_blank"
             style="font-size:0.85rem; color:#2563eb; text-decoration:none;">
            ⚙️ Apri editor tastierino
          </a>
        </div>`;
      kb.appendChild(footer);

      // Toggle visibilità
      toggleBtn.onclick = () => {
        kb.style.display = kb.style.display === "none" ? "block" : "none";
      };

      console.log("✅ Tastierino DSL Euporia pronto!");
    } catch (err) {
      console.error("❌ Errore nell’inizializzazione del tastierino:", err);
    }
  }

  // ==========================
  // 📦 PARSER FALLBACK DAL LEXER
  // ==========================
  async function parseFromLexer() {
    const res = await fetch(LEXER_PATH);
    if (!res.ok) throw new Error("Impossibile caricare EuporiaLexer.g4");
    const text = await res.text();
    const lines = text.split(/\r?\n/);

    const categoryRegex = /^\s*\/\/\s*===\s*(.+?)\s*===/;
    const tokenRegex = /^\s*([A-Z_]+)\s*:\s*([^;]+);/;
    const stringRegex = /'([^']+)'/g;

    const categories = new Map();
    const literalsMap = new Map();
    let currentCategory = "Altro";

    const PREFERRED = {
      DASH: ['-', '–', '—'],
      EMARK: ['!'],
      PLUS: ['+'],
      SLASH: ['/'],
      LPAR: ['('], RPAR: [')'],
      LBRAK: ['['], RBRAK: [']'],
      LCURL: ['{'], RCURL: ['}']
    };

    function resolveIdent(id) {
      const alts = literalsMap.get(id);
      if (!alts || !alts.length) return '';
      const pref = PREFERRED[id];
      if (pref) for (const p of pref) if (alts.includes(p)) return p;
      return alts[0];
    }

    function buildSymbolFromBlock(block) {
      const tokenOrString = /'([^']+)'|([A-Z][A-Z_]+)/g;
      let out = '';
      let mm;
      while ((mm = tokenOrString.exec(block)) !== null) {
        if (mm[1] !== undefined) out += mm[1];
        else if (mm[2] !== undefined) out += resolveIdent(mm[2]);
      }
      return out;
    }

    for (const line of lines) {
      const m = tokenRegex.exec(line);
      if (m) {
        const name = m[1];
        const block = m[2];
        const lits = [...block.matchAll(stringRegex)].map(x => x[1]);
        if (lits.length) literalsMap.set(name, lits);
      }
    }

    for (const line of lines) {
      const catMatch = categoryRegex.exec(line);
      if (catMatch) {
        currentCategory = catMatch[1].trim();
        if (!categories.has(currentCategory)) categories.set(currentCategory, []);
        continue;
      }

      const tokMatch = tokenRegex.exec(line);
      if (tokMatch) {
        const name = tokMatch[1];
        const block = tokMatch[2];
        if (/system/i.test(currentCategory)) continue;
        const symbol = buildSymbolFromBlock(block);
        if (!symbol) continue;
        const label = name.toLowerCase().replace(/_/g, " ");
        if (!categories.has(currentCategory)) categories.set(currentCategory, []);
        categories.get(currentCategory).push({ name, label, symbol });
      }
    }

    // Converti in oggetto semplice per compatibilità
    const obj = {};
    for (const [k, v] of categories.entries()) obj[k] = v;
    return obj;
  }

  initKeyboard();
});
