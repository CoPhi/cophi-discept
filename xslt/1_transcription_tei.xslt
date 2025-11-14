<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://himeros.eu/euporia" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0">
  <xsl:key name="kFigApp" match="apparatoFigureItem" use="normalize-space(figId)"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
      <!-- TEI Diplomatica -->
      <tei:TEI xmlns:tei="http://www.tei-c.org/ns/1.0">
      <tei:teiHeader>
        <tei:fileDesc>
          <tei:titleStmt>
            <tei:title>Beiträge zur bildnerischen Formlehre</tei:title>
            <tei:author>P. Klee</tei:author>
            <tei:respStmt>
              <tei:name>H. Hohenegger</tei:name>
              <tei:resp>Trascrizione diplomatica e edizione precritica</tei:resp>
            </tei:respStmt>
          </tei:titleStmt>
          <tei:publicationStmt> 
            <tei:publisher>Istituto Italiano di Studi Germanici</tei:publisher>
            <tei:pubPlace>Rome</tei:pubPlace>
            <tei:date>2025</tei:date>
          </tei:publicationStmt>
          <tei:sourceDesc>
            <tei:p></tei:p>
          </tei:sourceDesc>
        </tei:fileDesc>
      </tei:teiHeader>
        <tei:sourceDoc>
          <xsl:apply-templates select="//page" mode="diplomatica"/>
        </tei:sourceDoc>
        <tei:text>
          <xsl:apply-templates select="//page" mode="critica"/>
        </tei:text>
      </tei:TEI>
  </xsl:template>

  <!-- ********** DIPLOMATICA ********** -->
  <xsl:template match="page" mode="diplomatica">
    <xsl:variable name="facNum" select="normalize-space(facsimile/num)"/>
    <xsl:variable name="pageNum" select="normalize-space(numbZone/num)"/>

    <tei:surface n="{$facNum}">
    <tei:zone type="numberingZone" n="{$pageNum}"/>
      <xsl:apply-templates select="mainZone | mrgTextZoneIn | mrgTextZoneOut | mrgTextZoneUp | mrgTextZoneLow" mode="diplomatica"/>
    </tei:surface>
  </xsl:template>

  <xsl:template match="mrgTextZoneIn" mode="diplomatica">
    <tei:zone type="margin" subtype="inner">
      <xsl:apply-templates select="*" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneOut" mode="diplomatica">
    <tei:zone type="margin" subtype="outer">
      <xsl:apply-templates select="*" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneUp" mode="diplomatica">
    <tei:zone type="margin" subtype="upper">
      <xsl:apply-templates select="*" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneLow" mode="diplomatica">
    <tei:zone type="margin" subtype="lower">
      <xsl:apply-templates select="*" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>
  <xsl:template match="mainZone" mode="diplomatica">
    <tei:zone type="mainZone">
      <xsl:apply-templates select="sectionHeading | hdLineMargin| line | hdLinePause |placeholder | underlined | reference | expl" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>
  
  <xsl:template match="sectionHeading" mode="diplomatica">
    <xsl:variable name="level" select="string-length(normalize-space(level))"/>
    <xsl:variable name="typeRaw" select="normalize-space(sectionType/seg)"/>
    <xsl:variable name="typeLower"
      select="translate($typeRaw, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    
    <tei:line type="{concat('HeadingLine:', $typeLower)}" n="{$level}">
      <xsl:apply-templates select="line/textSeq/seg | line/textSeq/punct" mode="diplomatica"/>
    </tei:line>
  </xsl:template>
  
  <xsl:template match="hdLinePause" mode="diplomatica">
    <tei:milestone unit="*"/>
  </xsl:template>
  
  <xsl:template match="hdLineMargin" mode="diplomatica">
    <tei:zone type="margin" subtype="outer">
      <xsl:apply-templates select="line" mode="diplomatica">
        <xsl:with-param name="type" select="'hdLineMargin'"/>
      </xsl:apply-templates>
    </tei:zone>
  </xsl:template>

  <xsl:template match="underlined" mode="diplomatica">
    <tei:hi rend="underline">
      <xsl:apply-templates select="textSeq | num | operation" mode="diplomatica"/>
    </tei:hi>
  </xsl:template>
  
  <xsl:template match="pencilUnderlined" mode="diplomatica">
    <tei:hi rend="underline" type="pencil">
      <xsl:apply-templates select="textSeq | num | operation" mode="diplomatica"/>
    </tei:hi>
  </xsl:template>
  <xsl:template match="placeholder" mode="diplomatica">
    <xsl:apply-templates select="textSeq | operation" mode="diplomatica"/>
  </xsl:template>
  
  <xsl:template match="reference" mode="diplomatica">
    <tei:zone type="reference">
      <xsl:apply-templates select="line" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>

  <xsl:template match="expl" mode="diplomatica">
    <tei:zone type="explication">
      <xsl:apply-templates select="line" mode="diplomatica"/>
    </tei:zone>
  </xsl:template>

  <xsl:template match="line" mode="diplomatica">
    <xsl:param name="type"/>

    <tei:line>
        <!-- Aggiungi l'attributo type solo se il parametro type è presente -->
        <xsl:if test="$type">
            <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
            </xsl:attribute>
        </xsl:if>

        <!-- Applica i template per gli altri elementi come nel tuo codice originale -->
        <xsl:apply-templates select="textSeq/seg | textSeq/punct | operation" mode="diplomatica"/>
    </tei:line>
  </xsl:template>

  <xsl:template match="operation" mode="diplomatica">
      <xsl:apply-templates select="deletion | substitution | addition | pencilDeletion | subspencilDeletion | pencilAddition | subspencilAddition |phiDel| phiSub" mode="diplomatica"/>
  </xsl:template>

  <xsl:template match="substitution" mode="diplomatica">
      <xsl:apply-templates select="deletion" mode="diplomatica"/>
      <xsl:apply-templates select="replace" mode="diplomatica"/>
      <xsl:apply-templates select="addition" mode="diplomatica"/>
  </xsl:template>


  <!-- Trasformazione delle cancellature nella diplomatica -->
  <xsl:template match="deletion" mode="diplomatica">
    <tei:del>
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:del>
  </xsl:template>

  <xsl:template match="pencilDeletion" mode="diplomatica">
    <tei:del type="pencil">
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:del>
  </xsl:template>

  <xsl:template match="subspencilDeletion" mode="diplomatica">
    <tei:del type="pencil" hand="later">
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:del>
  </xsl:template>

  <!-- Trasformazione delle aggiunte nella diplomatica -->
  <xsl:template match="addition" mode="diplomatica">
    <tei:add>
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:add>
  </xsl:template>

  <!-- Trasformazione delle aggiunte nella diplomatica -->
  <xsl:template match="replace" mode="diplomatica">
    <tei:add>
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:add>
  </xsl:template>

  <xsl:template match="pencilAddition" mode="diplomatica">
    <tei:add type="pencil">
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:add>
  </xsl:template>

  <xsl:template match="subspencilAddition" mode="diplomatica">
    <tei:add type="pencil" hand="later">
      <!-- Applica template ai segmenti dentro textSeq -->
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="diplomatica"/>
    </tei:add>
  </xsl:template>

  <xsl:template match="phiDelete" mode="diplomatica">
    <xsl:apply-templates select="textSeq/seg" mode="diplomatica"/>
  </xsl:template>

  <xsl:template match="phiDel" mode="diplomatica">
    <xsl:apply-templates select="textSeq/seg" mode="diplomatica"/>
  </xsl:template>

  <xsl:template match="phiSub" mode="diplomatica">
      <xsl:value-of select="phiDelete/textSeq/seg | phiDelete/textSeq/punct"/>
  </xsl:template>

  <xsl:template match="phiAdd" mode="diplomatica">
  </xsl:template>

  <xsl:template match="textSeq" mode="diplomatica">
    <xsl:apply-templates select="seg | punct" mode="diplomatica"/>
  </xsl:template>

  <xsl:template match="seg" mode="diplomatica">
    <tei:seg>
      <!-- Prefix -->
      <xsl:if test="prefix">
        <xsl:value-of select="translate(prefix, '^', '')"/>
      </xsl:if>

      <!-- Prima operation -->
      <xsl:choose>
        <xsl:when test="operation[1]/phiSub">
            <xsl:value-of select="operation[1]/phiSub/phiDelete/textSeq/seg"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="operation[1]/*" mode="diplomatica"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Infix tra le due operazioni -->
      <xsl:if test="infix and count(operation) > 1">
        <xsl:value-of select="translate(infix, '^', '')"/>
      </xsl:if>

      <!-- Seconda operation (se presente) -->
      <xsl:if test="operation[2]">
        <xsl:choose>
          <xsl:when test="operation[2]/phiSub">
              <xsl:value-of select="operation[2]/phiSub/phiDelete/textSeq/seg"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="operation[2]/*" mode="diplomatica"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <!-- Suffix -->
      <xsl:if test="suffix">
        <xsl:value-of select="translate(suffix, '^', '')"/>
      </xsl:if>

      <!-- Caso senza operation/prefix/suffix -->
      <xsl:if test="not(prefix) and not(suffix) and not(operation)">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:if>
    </tei:seg>
  </xsl:template>

  <xsl:template match="punct" mode="diplomatica">
    <tei:pc>
      <xsl:value-of select="normalize-space(.)"/>
    </tei:pc>
  </xsl:template>

  <!-- ********** CRITICA ********** -->
  <xsl:template match="page" mode="critica">
    <xsl:variable name="facNum" select="normalize-space(facsimile/num)"/>
    <xsl:variable name="pageNum" select="normalize-space(numbZone/num)"/>
    
    <tei:pb n="{$pageNum}" facs="{$facNum}"/>
    <!-- Mantieni l’ordine naturale della pagina: -->
    <xsl:apply-templates select="openPar | sectionHeading| hdLineMargin| mainZone/* | mrgTextZoneIn | mrgTextZoneOut | mrgTextZoneUp | mrgTextZoneLow| graphZoneFig" mode="critica"/>
  </xsl:template>
  <!-- ********** MARGINAL ZONES — CRITICA ********** -->
  <xsl:template match="mrgTextZoneIn" mode="critica">
    <tei:div type="margin" place="inner">
      <xsl:apply-templates select="*" mode="critica"/>
    </tei:div>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneOut" mode="critica">
    <tei:div type="margin" place="outer">
      <xsl:apply-templates select="*" mode="critica"/>
    </tei:div>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneUp" mode="critica">
    <tei:div type="margin" place="upper">
      <xsl:apply-templates select="*" mode="critica"/>
    </tei:div>
  </xsl:template>
  
  <xsl:template match="mrgTextZoneLow" mode="critica">
    <tei:div type="margin" place="lower">
      <xsl:apply-templates select="*" mode="critica"/>
    </tei:div>
  </xsl:template>

  
  <xsl:template match="sectionHeading" mode="critica">
    <xsl:variable name="level" select="string-length(normalize-space(level))"/>
    <xsl:variable name="typeRaw" select="normalize-space(sectionType/seg)"/>
    <xsl:variable name="typeLower"
      select="translate($typeRaw, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    
    <tei:head type="{$typeLower}" n="{$level}">
      <xsl:apply-templates select="line/textSeq/seg | line/textSeq/punct" mode="critica"/>
    </tei:head>
  </xsl:template>

  <xsl:template match="hdLineMargin" mode="critica">
    <tei:head type="margin" place="margin">
      <xsl:apply-templates select="line/textSeq/seg | line/textSeq/punct" mode="critica"/>
    </tei:head>
  </xsl:template>
  <xsl:template match="hdLinePause" mode="critica">
    <tei:milestone unit="*"/>
  </xsl:template>
  
  <xsl:template match="underlined" mode="critica">
    <tei:hi rend="underline">
      <xsl:apply-templates select="textSeq | num | operation" mode="critica"/>
    </tei:hi>
  </xsl:template>
  
  <xsl:template match="pencilUnderlined" mode="critica">
    <tei:hi rend="underline" type="pencil">
      <xsl:apply-templates select="textSeq | num | operation" mode="critica"/>
    </tei:hi>
  </xsl:template>
  
  <xsl:template match="placeholder" mode="critica">
    <!-- trova la prima reference successiva nella stessa pagina -->
    <xsl:variable name="ref"
      select="following-sibling::reference[1]" />
    
    <xsl:choose>
      <!-- se la reference esiste -->
      <xsl:when test="$ref">
        <xsl:apply-templates select="$ref/line" mode="critica"/>
      </xsl:when>
      <!-- altrimenti mostra solo il placeholder -->
      <xsl:otherwise>
        <xsl:apply-templates select="textSeq | operation" mode="critica"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ********** EXPLICATION — CRITICA ********** -->
  <xsl:template match="expl" mode="critica">
    <tei:note type="explication">
      <!-- Prima riga come etichetta -->
      <xsl:if test="line[1]">
        <tei:label>
          <xsl:apply-templates select="line[1]" mode="critica"/>
        </tei:label>
      </xsl:if>
      <!-- Resto delle righe come contenuto -->
      <tei:p>
        <xsl:apply-templates select="line[position() > 1]" mode="critica"/>
      </tei:p>
    </tei:note>
  </xsl:template>

  <xsl:template match="openPar" mode="critica">
    <tei:openPAR/>
  </xsl:template>

  <xsl:template match="line" mode="critica">
      <xsl:apply-templates select="textSeq/seg | textSeq/punct | operation" mode="critica"/>
  </xsl:template>

  <xsl:template match="operation" mode="critica">
      <xsl:apply-templates select="deletion | substitution | addition | pencilDeletion | subspencilDeletion | pencilAddition | subspencilAddition |phiAdd| phiSub" mode="critica"/>
  </xsl:template>

  <xsl:template match="phiAdd" mode="critica">
    <tei:supplied>
      <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
    </tei:supplied>
  </xsl:template>

  <xsl:template match="substitution" mode="critica">
      <xsl:apply-templates select="replace | addition | pencilAddition | subspencilAddition" mode="critica"/>
  </xsl:template>

  <xsl:template match="phiSub" mode="critica">
    <xsl:apply-templates select="phiReplace" mode="critica"/>
  </xsl:template>

  <xsl:template match="phiReplace" mode="critica">
    <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
  </xsl:template>

    <!-- Gestione delle aggiunte nella critica -->
  <xsl:template match="addition" mode="critica">
    <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
  </xsl:template>

  <xsl:template match="replace" mode="critica">
    <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
  </xsl:template>

  <xsl:template match="pencilAddition" mode="critica">
    <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
  </xsl:template>

  <xsl:template match="subspencilAddition" mode="critica">
    <xsl:apply-templates select="textSeq/seg | textSeq/punct" mode="critica"/>
  </xsl:template>

  <xsl:template match="seg" mode="critica">
    <xsl:variable name="current" select="."/>
    <xsl:variable name="prev" select="preceding::seg[1]"/>
    <xsl:variable name="next" select="following::seg[1]"/>

    <xsl:choose>
    <!-- Questo seg è stato già unito col precedente: non mostrarlo -->
      <xsl:when test="substring(normalize-space($prev), string-length(normalize-space($prev))) = '-'">
      <!-- non fare nulla -->
      </xsl:when>

    <!-- Questo seg termina con "-" → uniscilo al successivo -->
      <xsl:when test="substring(normalize-space($current), string-length(normalize-space($current))) = '-'">
        <tei:w>
          <xsl:value-of select="substring(normalize-space($current), 1, string-length(normalize-space($current)) - 1)"/>
          <xsl:value-of select="normalize-space($next)"/>
        </tei:w>
      </xsl:when>

    <!-- Caso con strutture complesse (prefix, operation, ecc.) -->
      <xsl:when test="prefix or suffix or operation">
       <tei:w>
          <xsl:if test="prefix">
           <xsl:value-of select="translate(prefix, '^', '')"/>
          </xsl:if>

        <xsl:choose>
          <xsl:when test="operation[1]/addition">
              <xsl:value-of select="operation[1]/addition/textSeq/seg"/>
          </xsl:when>
          <xsl:when test="operation[1]/pencilAddition">
              <xsl:value-of select="operation[1]/pencilAddition/textSeq/seg"/>
          </xsl:when>
          <xsl:when test="operation[1]/subspencilAddition">
              <xsl:value-of select="operation[1]/subspencilAddition/textSeq/seg"/>
          </xsl:when>
          <xsl:when test="operation[1]/phiSub">
            <tei:choice>
              <tei:sic>
                <xsl:apply-templates select="operation[1]/phiSub/phiDelete/textSeq/seg"/>
              </tei:sic>
              <tei:corr>
                <xsl:apply-templates select="operation[1]/phiSub/phiReplace/textSeq/seg"/>
              </tei:corr>
            </tei:choice>
          </xsl:when>
          <xsl:when test="operation[1]/substitution">
              <xsl:value-of select="operation[1]/substitution/addition/textSeq/seg"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="operation[1]/*" mode="critica"/>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Infix tra due operazioni -->
         <xsl:if test="infix and count(operation) > 1">
           <xsl:value-of select="translate(infix, '^', '')"/>
         </xsl:if>

        <!-- Seconda operation -->
         <xsl:if test="operation[2]">
           <xsl:choose>
             <xsl:when test="operation[2]/addition">
                 <xsl:value-of select="operation[2]/addition/textSeq/seg"/>
             </xsl:when>
             <xsl:when test="operation[2]/substitution">
                 <xsl:value-of select="operation[2]/substitution/addition/textSeq/seg"/>
             </xsl:when>
             <xsl:when test="operation[2]/phiSub">
               <tei:choice>
                 <tei:sic>
                   <xsl:apply-templates select="operation[2]/phiSub/phiDelete/textSeq/seg"/>
                 </tei:sic>
                 <tei:corr>
                   <xsl:apply-templates select="operation[2]/phiSub/phiReplace/textSeq/seg"/>
                 </tei:corr>
               </tei:choice>
             </xsl:when>
             <xsl:otherwise>
               <xsl:apply-templates select="operation[2]/*" mode="critica"/>
             </xsl:otherwise>
           </xsl:choose>         </xsl:if>

        <!-- Suffix -->
          <xsl:if test="suffix">
           <xsl:value-of select="translate(suffix, '^', '')"/>
         </xsl:if>
        </tei:w>
     </xsl:when>

    <!-- Caso normale -->
      <xsl:otherwise>
        <tei:w>
          <xsl:value-of select="normalize-space($current)"/>
        </tei:w>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Gestione della punteggiatura nella critica -->
  <xsl:template match="punct" mode="critica">
    <tei:pc>
      <xsl:value-of select="normalize-space(.)"/>
    </tei:pc>
  </xsl:template>

  <!-- Eliminazione delle cancellature nella critica -->
  <xsl:template match="deletion" mode="critica">
    <!-- Non genera alcun output -->
  </xsl:template>
  
  
  







  <!-- swallow whitespace-only text nodes to avoid stray newlines/spaces -->
  <xsl:template match="text()[normalize-space()='']"/>

  <!-- Scoped mode for labeltext to avoid emitting stray text globally -->

  <!-- ===== Scoped mode per labeltext (nessun <tei:ref> dentro label) ===== -->
  <xsl:template match="labeltext" mode="label">
    <xsl:apply-templates select="node()" mode="label"/>
  </xsl:template>

  <xsl:template match="line_app" mode="label">
    <xsl:apply-templates select="node()" mode="label"/>
  </xsl:template>

  <xsl:template match="textSeqinfig" mode="label">
    <xsl:apply-templates select="node()" mode="label"/>
  </xsl:template>

  <xsl:template match="seginfig" mode="label">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

  <xsl:template match="punctinfig" mode="label">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- refSeries dentro labeltext -> testo piatto (es. " 2/3/4") -->
  <xsl:template match="refSeries" mode="label">
  <xsl:text> </xsl:text>
  <xsl:for-each select="refItem">
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:if test="position()!=last()"><xsl:text>/</xsl:text></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Operazioni *_app dentro label -->
  <xsl:template match="underlined_app" mode="label">
    <tei:hi rend="underline"><xsl:apply-templates mode="label"/></tei:hi>
  </xsl:template>
  <xsl:template match="pencil_app" mode="label">
    <tei:hi rend="pencil"><xsl:apply-templates mode="label"/></tei:hi>
  </xsl:template>
  
  
  
  <xsl:template match="deletion_app" mode="label">
    <tei:del><xsl:apply-templates mode="label"/></tei:del>
  </xsl:template>
  <xsl:template match="pencilDeletion_app" mode="label">
    <tei:del type="pencil"><xsl:apply-templates mode="label"/></tei:del>
  </xsl:template>
  <xsl:template match="subspencilDeletion_app" mode="label">
    <tei:del type="pencil-subsequent"><xsl:apply-templates mode="label"/></tei:del>
  </xsl:template>
  
  

  <!-- ===== Default-mode per apparatus (per textinfig -> ab/p) ===== -->
  <xsl:template match="line_app">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="textSeqinfig">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  

  

  <!-- refSeries fuori da labeltext: rappresentazione strutturata -->
  <xsl:template match="refSeries">
    <xsl:for-each select="refItem">
      <tei:ref><xsl:value-of select="normalize-space(.)"/></tei:ref>
      <xsl:if test="position()!=last()"><tei:pc>/</tei:pc></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Operazioni *_app in default mode -->
  <xsl:template match="underlined_app">
    <tei:hi rend="underline"><xsl:apply-templates/></tei:hi>
  </xsl:template>
  <xsl:template match="pencil_app">
    <tei:hi rend="pencil"><xsl:apply-templates/></tei:hi>
  </xsl:template>
  
  
  
  <xsl:template match="deletion_app">
    <tei:del><xsl:apply-templates/></tei:del>
  </xsl:template>
  <xsl:template match="pencilDeletion_app">
    <tei:del type="pencil"><xsl:apply-templates/></tei:del>
  </xsl:template>
  <xsl:template match="subspencilDeletion_app">
    <tei:del type="pencil-subsequent"><xsl:apply-templates/></tei:del>
  </xsl:template>
  
  

  <!-- Critica-like behavior in label: deletions suppressed, additions visible, phiAdd as supplied -->
  <xsl:template match="deletion_app" mode="label"/>
  <xsl:template match="pencilDeletion_app" mode="label"/>
  <xsl:template match="subspencilDeletion_app" mode="label"/>

  <xsl:template match="addition_app" mode="label">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
  </xsl:template>
  <xsl:template match="pencilAddition_app" mode="label">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
  </xsl:template>
  <xsl:template match="subspencilAddition_app" mode="label">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
  </xsl:template>
  <xsl:template match="replace_app" mode="label">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
  </xsl:template>

  <xsl:template match="substitution_app" mode="label">
    <xsl:apply-templates select="replace_app | addition_app | pencilAddition_app | subspencilAddition_app" mode="label"/>
  </xsl:template>

  <xsl:template match="phiAdd_app" mode="label">
    <tei:supplied>
      <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
    </tei:supplied>
  </xsl:template>

  <xsl:template match="phiSub_app" mode="label">
    <xsl:apply-templates select="phiReplace_app" mode="label"/>
  </xsl:template>
  <xsl:template match="phiReplace_app" mode="label">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig" mode="label"/>
  </xsl:template>

  <!-- Critica-like behavior in default mode (for <tei:ab>): deletions suppressed, additions visible, phiAdd as supplied -->
  <xsl:template match="deletion_app"/>
  <xsl:template match="pencilDeletion_app"/>
  <xsl:template match="subspencilDeletion_app"/>

  <xsl:template match="addition_app">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
  </xsl:template>
  <xsl:template match="pencilAddition_app">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
  </xsl:template>
  <xsl:template match="subspencilAddition_app">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
  </xsl:template>
  <xsl:template match="replace_app">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
  </xsl:template>

  <xsl:template match="substitution_app">
    <xsl:apply-templates select="replace_app | addition_app | pencilAddition_app | subspencilAddition_app"/>
  </xsl:template>

  <xsl:template match="phiAdd_app">
    <tei:supplied>
      <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
    </tei:supplied>
  </xsl:template>

  <xsl:template match="phiSub_app">
    <xsl:apply-templates select="phiReplace_app"/>
  </xsl:template>
  <xsl:template match="phiReplace_app">
    <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig"/>
  </xsl:template>
  <!-- === Apparatus: word & punctuation === -->
  <xsl:template match="seginfig">
    <xsl:variable name="current" select="."/>
    <xsl:variable name="prev" select="preceding-sibling::seginfig[1]"/>
    <xsl:variable name="next" select="following-sibling::seginfig[1]"/>

    <xsl:choose>
      <!-- Skip if previous ended with '-' (joined there) -->
      <xsl:when test="substring(normalize-space($prev), string-length(normalize-space($prev))) = '-'"/>
      
      <!-- If this ends with '-' join with next -->
      <xsl:when test="substring(normalize-space($current), string-length(normalize-space($current))) = '-'">
        <tei:w>
          <xsl:value-of select="substring(normalize-space($current), 1, string-length(normalize-space($current)) - 1)"/>
          <xsl:value-of select="normalize-space($next)"/>
        </tei:w>
      </xsl:when>

      <!-- Complex piece (prefix/suffix/operations) -->
      <xsl:when test="prefix_app or suffix_app or operation_app">
        <!-- build flat text parts to keep <tei:w> children text-only -->
        <xsl:variable name="prefix" select="translate(normalize-space(prefix_app), '^', '')"/>
        <xsl:variable name="suffix" select="translate(normalize-space(suffix_app), '^', '')"/>
        <xsl:variable name="infix"  select="translate(normalize-space(infix_app), '^', '')"/>

        <xsl:variable name="core1">
          <xsl:choose>
            <xsl:when test="operation_app[1]/addition_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[1]/addition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:when test="operation_app[1]/pencilAddition_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[1]/pencilAddition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:when test="operation_app[1]/subspencilAddition_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[1]/subspencilAddition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:when test="operation_app[1]/phiSub_app">
              <!-- phi substitution: produce <choice> with w children -->
              <tei:choice>
                <tei:sic>
                  <tei:w>
                    <xsl:value-of select="normalize-space(string-join(operation_app[1]/phiSub_app/phiDelete_app/textSeqinfig/seginfig,' '))"/>
                  </tei:w>
                </tei:sic>
                <tei:corr>
                  <tei:w>
                    <xsl:value-of select="normalize-space(string-join(operation_app[1]/phiSub_app/phiReplace_app/textSeqinfig/seginfig,' '))"/>
                  </tei:w>
                </tei:corr>
              </tei:choice>
            </xsl:when>
            <xsl:when test="operation_app[1]/substitution_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[1]/substitution_app/addition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="core2">
          <xsl:choose>
            <xsl:when test="operation_app[2]/addition_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[2]/addition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:when test="operation_app[2]/substitution_app">
              <xsl:value-of select="normalize-space(string-join(operation_app[2]/substitution_app/addition_app/textSeqinfig/seginfig,' '))"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:variable>

        <!-- If we did NOT emit a <choice> above (core1 has no elements), output a <tei:w> -->
        <xsl:if test="not(operation_app[1]/phiSub_app)">
          <tei:w>
            <xsl:value-of select="concat($prefix, $core1, (if (string-length($infix)&gt;0 and string-length($core2)&gt;0) then $infix else ''), $core2, $suffix)"/>
          </tei:w>
        </xsl:if>
      </xsl:when>

      <!-- Normal token -->
      <xsl:otherwise>
        <tei:w>
          <xsl:value-of select="normalize-space($current)"/>
        </tei:w>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="punctinfig">
    <tei:pc><xsl:value-of select="normalize-space(.)"/></tei:pc>
  </xsl:template>
  <!-- Figure zone -> TEI figure with label and ab from apparatoFigure -->
  <xsl:template match="graphZoneFig">
    <xsl:variable name="id" select="normalize-space(figId)"/>
    <xsl:variable name="app" select="key('kFigApp', $id)[1]"/>

    <tei:figure xml:id="{concat('fig-', translate($id, ' ', '')}">
      <!-- LABEL: prefer apparato label if present -->
      <xsl:choose>
        <xsl:when test="$app/label/labeltext">
          <tei:label>
            <xsl:apply-templates select="$app/label/labeltext/node()" mode="label"/>
          </tei:label>
        </xsl:when>
        <xsl:otherwise>
          <tei:label>
            <xsl:text>fig. </xsl:text>
            <xsl:value-of select="normalize-space(substring-after($id,'_'))"/>
            <xsl:text>.</xsl:text>
          </tei:label>
        </xsl:otherwise>
      </xsl:choose>

      <!-- AB: lines from textinfig -->
      <xsl:if test="$app/textinfig">
        <tei:ab>
          <xsl:for-each select="$app/textinfig/line_app">
            <tei:p>
              <xsl:apply-templates select="textSeqinfig/seginfig | textSeqinfig/punctinfig | operation_app"/>
            </tei:p>
          </xsl:for-each>
        </tei:ab>
      </xsl:if>
    </tei:figure>
  </xsl:template>

</xsl:stylesheet>