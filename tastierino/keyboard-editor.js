// keyboard-editor.js — Editor Tastierino Euporia (con escape sicuro per tutti i simboli + caricamento JSON)
window.addEventListener("DOMContentLoaded", () => {
  console.log("⚙️ Keyboard Editor Euporia — avviato");

  const list = document.getElementById("list");
  const loadBtn = document.getElementById("load");
  const addBtn = document.getElementById("add");
  const exportBtn = document.getElementById("export");

  const LEXER_PATH = "js/euporia/src/EuporiaLexer.g4";
  const JSON_PATH = "js/keyboard-config.json";
  let data = [];

  // === Escape/Unescape HTML universale ===
  function escapeHTML(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function unescapeHTML(str) {
    const temp = document.createElement("textarea");
    temp.innerHTML = str;
    return temp.value;
  }

  // === Utility fetch ===
  async function fetchText(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`Impossibile caricare ${url}: ${res.status}`);
    return res.text();
  }

  async function fetchJSON(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`JSON non trovato (${res.status})`);
    return res.json();
  }

  // === Parsing del lexer ===
  async function loadLexer() {
    console.log("📄 Carico marcature da", LEXER_PATH);
    const text = await fetchText(LEXER_PATH);
    const lines = text.split(/\r?\n/);

    const categoryRegex = /^\s*\/\/\s*===\s*(.+?)\s*===/;
    const tokenRegex = /^\s*([A-Z_]+)\s*:\s*([^;]+);/;
    const stringRegex = /'([^']+)'/g;

    let currentCategory = "Altro";
    let categories = new Map();
    let literalsMap = new Map();

    // raccoglie i literal
    for (const line of lines) {
      const m = tokenRegex.exec(line);
      if (m) {
        const name = m[1];
        const block = m[2];
        const lits = [...block.matchAll(stringRegex)].map(x => x[1]);
        if (lits.length) literalsMap.set(name, lits);
      }
    }

    // costruisce i simboli leggibili
    function buildSymbolFromBlock(block) {
      const tokenOrString = /'([^']+)'|([A-Z][A-Z_]+)/g;
      let out = '';
      let mm;
      while ((mm = tokenOrString.exec(block)) !== null) {
        if (mm[1] !== undefined) out += mm[1];
        else if (mm[2] !== undefined && literalsMap.has(mm[2]))
          out += literalsMap.get(mm[2])[0];
      }
      return out;
    }

    // parsing principale
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
        if (/system/i.test(currentCategory) || name.startsWith("SYSTEM_")) continue;
        const symbol = buildSymbolFromBlock(block);
        if (!symbol) continue;
        const label = name.toLowerCase().replace(/_/g, " ");
        if (!categories.has(currentCategory)) categories.set(currentCategory, []);
        categories.get(currentCategory).push({ name, symbol, label, category: currentCategory });
      }
    }

    data = [];
    for (const [cat, arr] of categories.entries()) {
      data.push(...arr);
    }

    renderList();
    console.log(`✅ Caricate ${data.length} marcature dal lexer`);
  }

  // === Rendering righe editabili ===
  function renderList() {
    list.innerHTML = "";

    const header = document.createElement("div");
    header.className = "token-row header";
    header.innerHTML = `
      <div>#</div>
      <div>Nome</div>
      <div>Simbolo</div>
      <div>Etichetta</div>
      <div>Categoria</div>
      <div></div>
    `;
    list.appendChild(header);

    data.forEach((t, i) => {
      const row = document.createElement("div");
      row.className = "token-row";
      row.innerHTML = `
        <div>${i + 1}</div>
        <input type="text" value="${escapeHTML(t.name)}" />
        <input type="text" value="${escapeHTML(t.symbol)}" placeholder="Simbolo" />
        <input type="text" value="${escapeHTML(t.label)}" />
        <input type="text" value="${escapeHTML(t.category)}" />
        <button title="Elimina">🗑️</button>
      `;

      const [nameIn, symIn, labelIn, catIn, delBtn] = row.querySelectorAll("input,button");

      nameIn.addEventListener("input", () => (t.name = nameIn.value));
      symIn.addEventListener("input", () => (t.symbol = symIn.value));
      labelIn.addEventListener("input", () => (t.label = labelIn.value));
      catIn.addEventListener("input", () => (t.category = catIn.value));

      delBtn.addEventListener("click", () => {
        data.splice(i, 1);
        renderList();
      });

      list.appendChild(row);
    });
  }

  // === Aggiungi nuovo tasto ===
  addBtn.addEventListener("click", () => {
    const name = prompt("Nome del token:");
    const symbol = prompt("Simbolo da inserire:");
    const label = prompt("Etichetta visibile:");
    const category = prompt("Categoria:");
    if (!name || !symbol || !label || !category) return;
    data.unshift({ name, symbol, label, category });
    renderList();
  });

  // === Esporta JSON ===
  exportBtn.addEventListener("click", () => {
    const grouped = {};
    for (const t of data) {
      if (!grouped[t.category]) grouped[t.category] = [];
      grouped[t.category].push({
        name: unescapeHTML(t.name),
        label: unescapeHTML(t.label),
        symbol: unescapeHTML(t.symbol)
      });
    }
    const blob = new Blob([JSON.stringify({ categories: grouped }, null, 2)], {
      type: "application/json"
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "keyboard-config.json";
    a.click();
  });

  // === Carica automaticamente il JSON se esiste ===
  async function loadJSONIfExists() {
    try {
      console.log("🔍 Cerco un JSON salvato in", JSON_PATH);
      const json = await fetchJSON(JSON_PATH);
      data = [];
      for (const [cat, tokens] of Object.entries(json.categories || {})) {
        tokens.forEach(t => data.push({
          name: t.name,
          symbol: t.symbol,
          label: t.label,
          category: cat
        }));
      }
      renderList();
      console.log(`✅ Caricato tastierino personalizzato da JSON (${data.length} marcature)`);
    } catch (err) {
      console.warn("⚠️ Nessun JSON trovato, puoi caricare dal lexer:", err.message);
    }
  }

  // === Eventi principali ===
  loadBtn.addEventListener("click", loadLexer);
  loadJSONIfExists();
});
