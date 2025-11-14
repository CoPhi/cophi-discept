<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei"
                version="1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- ====== TEMPLATE IDENTITÀ ====== -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- ====== ROOT TEI ====== -->
    <xsl:template match="/tei:TEI">
        <xsl:copy>
            <xsl:apply-templates select="tei:teiHeader | tei:sourceDoc"/>
            <xsl:apply-templates select="tei:text"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- ====== TEXT → BODY ====== -->
    <xsl:template match="tei:text">
        <tei:text>
            <tei:body>
                <xsl:call-template name="group-by-head-level">
                    <xsl:with-param name="nodes" select="*"/>
                    <xsl:with-param name="current-level" select="0"/>
                </xsl:call-template>
            </tei:body>
        </tei:text>
    </xsl:template>
    
    <!-- ====== LOGICA PRINCIPALE ====== -->
    <xsl:template name="group-by-head-level">
        <xsl:param name="nodes"/>
        <xsl:param name="current-level"/>
        
        <xsl:if test="count($nodes) &gt; 0">
            <xsl:variable name="first" select="$nodes[1]"/>
            <xsl:variable name="rest" select="$nodes[position() &gt; 1]"/>
            
            <xsl:choose>
                
                <!-- HEAD: apre un nuovo DIV -->
                <xsl:when test="$first[self::tei:head]">
                    <xsl:variable name="level" select="number($first/@n)"/>
                    <xsl:variable name="type" select="$first/@type"/>
                    
                    <!-- contenuto di questo div -->
                    <xsl:variable name="content"
                        select="$rest[
                                not(self::tei:head)
                                or number(@n) &gt; $level
                            ]"/>
                    
                    <tei:div>
                        <xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
                        <xsl:attribute name="n"><xsl:value-of select="$level"/></xsl:attribute>
                        <xsl:copy-of select="$first"/>
                        
                        <!-- Ricorsione interna -->
                        <xsl:call-template name="group-by-head-level">
                            <xsl:with-param name="nodes" select="$content"/>
                            <xsl:with-param name="current-level" select="$level"/>
                        </xsl:call-template>
                    </tei:div>
                    
                    <!-- fratelli successivi -->
                    <xsl:variable name="remaining"
                        select="$rest[self::tei:head and number(@n) &lt;= $level]"/>
                    <xsl:call-template name="group-by-head-level">
                        <xsl:with-param name="nodes" select="$remaining"/>
                        <xsl:with-param name="current-level" select="$current-level"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- OPENPAR: apre un paragrafo -->
                <xsl:when test="$first[self::tei:openPAR]">
                    <tei:p>
                        <xsl:call-template name="collect-paragraph">
                            <xsl:with-param name="nodes" select="$rest"/>
                        </xsl:call-template>
                    </tei:p>
                    
                    <!-- salta i nodi del paragrafo -->
                    <xsl:variable name="remaining">
                        <xsl:call-template name="skip-paragraph">
                            <xsl:with-param name="nodes" select="$rest"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:call-template name="group-by-head-level">
                        <xsl:with-param name="nodes" select="$remaining/*"/>
                        <xsl:with-param name="current-level" select="$current-level"/>
                    </xsl:call-template>
                </xsl:when>
                
                <!-- altri nodi -->
                <xsl:otherwise>
                    <xsl:copy-of select="$first"/>
                    <xsl:call-template name="group-by-head-level">
                        <xsl:with-param name="nodes" select="$rest"/>
                        <xsl:with-param name="current-level" select="$current-level"/>
                    </xsl:call-template>
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- ====== COLLECT-PARAGRAPH ====== -->
    <xsl:template name="collect-paragraph">
        <xsl:param name="nodes"/>
        <xsl:if test="count($nodes) &gt; 0">
            <xsl:variable name="first" select="$nodes[1]"/>
            <xsl:variable name="rest" select="$nodes[position() &gt; 1]"/>
            
            <xsl:choose>
                <xsl:when test="$first[self::tei:openPAR or self::tei:head]"/>
                <xsl:otherwise>
                    <xsl:copy-of select="$first"/>
                    <xsl:call-template name="collect-paragraph">
                        <xsl:with-param name="nodes" select="$rest"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- ====== SKIP-PARAGRAPH ====== -->
    <xsl:template name="skip-paragraph">
        <xsl:param name="nodes"/>
        <xsl:choose>
            <xsl:when test="count($nodes)=0 or $nodes[1][self::tei:openPAR or self::tei:head]">
                <xsl:copy-of select="$nodes"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="skip-paragraph">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
