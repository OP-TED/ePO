<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : CommonFunctions.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : Common Functions: SPARQL queries to insert triples
    ####################################################################################
    -->
    
    <!-- Include Prefixes into the ontology -->
    <xsl:template name="prefixes">
        <xsl:text>PREFIX : &lt;http://data.europa.eu/ePO/ontology#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX org: &lt;http://www.w3.org/ns/org#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX vcard: &lt;http://www.w3.org/2006/vcard/ns#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX rov: &lt;http://www.w3.org/ns/regorg#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX adms: &lt;http://www.w3.org/ns/adms#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX ccts: &lt;http://www.unece.org/cefact#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX euvoc: &lt;http://publications.europa.eu/ontology/euvoc#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX ubl: &lt;http://docs.oasis-open.org/ubl#&gt;&#x0A;</xsl:text>
        <xsl:text>PREFIX epo-rd: &lt;http://data.europa.eu/ePO/referencedata#&gt;&#x0A;</xsl:text>
    </xsl:template>
    
    <!-- SPARQL Insert individual send via parameter -->
    <xsl:template name="create_individual">
        <xsl:param name="subject"/>
        <xsl:param name="object"/>
        
        <xsl:call-template name="create_individual_begin">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="object" select="$object"/>
        </xsl:call-template>
        <xsl:call-template name="create_individual_end"/>
    </xsl:template>
    
    <!-- SPARQL Insert -->
    <xsl:template name="create_insert">
        <xsl:text>&#x0A;INSERT DATA&#x0A;{&#x0A;</xsl:text>
        <xsl:text>&#009;Graph &lt;http://data.europa.eu/ePO/ontology&gt;{&#x0A;</xsl:text>        
    </xsl:template>
    <xsl:template name="create_insert_where">
        <xsl:text>&#x0A;INSERT&#x0A;{&#x0A;</xsl:text>
        <xsl:text>&#009;Graph &lt;http://data.europa.eu/ePO/ontology&gt;{&#x0A;</xsl:text>        
    </xsl:template>
    
    <!-- SPARQL Close query -->
    <xsl:template name="create_individual_end">
        <xsl:text>&#x0A;&#009;}&#x0A;</xsl:text>
        <xsl:text>&#x0A;};&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template name="create_individual_end_where">
        <xsl:text>&#x0A;&#009;}&#x0A;</xsl:text>
        <xsl:text>&#x0A;}&#x0A;</xsl:text>
    </xsl:template>
    
    <!-- SPARQL Insert individual but not close query -->
    <xsl:template name="create_individual_begin">
        <xsl:param name="subject"/>
        <xsl:param name="object"/>
        
        <xsl:call-template name="create_insert"/>
        
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="$object"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="create_individual_begin_where">
        <xsl:param name="subject"/>
        <xsl:param name="object"/>
        
        <xsl:call-template name="create_insert_where"/>
        
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="$object"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- SPARQL Insert property without subject -->
    <xsl:template name="add_property_no_subject">
        <xsl:param name="predicate"/>
        <xsl:param name="object"/>
        <xsl:param name="last"/>
        
        <xsl:text>&#009;&#009;&#009;</xsl:text>
        <xsl:value-of select="$predicate"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$object"/>
        
        <xsl:if test="$last = true()"><xsl:text>.&#x0A;</xsl:text></xsl:if>
        <xsl:if test="$last = false()"><xsl:text>;&#x0A;</xsl:text></xsl:if>        
    </xsl:template>
    
    <xsl:template name="filter">
        <xsl:param name="filter_triple"/>
        
        <xsl:call-template name="create_individual_end_where"/>
        
        <xsl:text>where{</xsl:text>
        <xsl:text>&#009;filter not EXISTS{</xsl:text>
        <xsl:value-of select="$filter_triple"/>
        <xsl:text>}&#x0A;</xsl:text>
        <xsl:text>};</xsl:text>
    </xsl:template>
    
    <xsl:template name="select">
        <xsl:param name="select_triple"/>
        
        <xsl:call-template name="create_individual_end_where"/>
        
        <xsl:text>where{</xsl:text>
        <xsl:text>&#009;select ?a where {</xsl:text>
        <xsl:value-of select="$select_triple"/>
        <xsl:text>}&#x0A;</xsl:text>
        <xsl:text>};</xsl:text>
    </xsl:template>
    
    <!-- SPARQL Insert property without subject as string -->
    <xsl:template name="add_property_no_subject_string">
        <xsl:param name="triple"/>
        
        <xsl:text>&#009;&#009;&#009;</xsl:text>
        <xsl:value-of select="$triple"/>
        <xsl:text>&#x0A;</xsl:text>    
    </xsl:template>
    
    <!-- SPARQL Insert triple -->
    <xsl:template name="add_property">
        <xsl:param name="subject"/>
        <xsl:param name="predicate"/>
        <xsl:param name="object"/>
        <xsl:param name="last"/>
        
        <xsl:text>&#009;&#009;</xsl:text>
        <xsl:value-of select="$subject"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$predicate"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$object"/>
        
        <xsl:if test="$last = true()"><xsl:text>.&#x0A;</xsl:text></xsl:if>
        <xsl:if test="$last = false()"><xsl:text>;&#x0A;</xsl:text></xsl:if>        
    </xsl:template>
    
    <!-- SPARQL Insert triple as string -->
    <xsl:template name="add_property_string">
        <xsl:param name="triple"/>
        
        <xsl:text>&#009;&#009;</xsl:text>
        <xsl:value-of select="$triple"/>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>
    
    <!-- SPARQL End triple -->
    <xsl:template name="end_triple">
        <xsl:text>&#009;&#009;</xsl:text>
        <xsl:text>.</xsl:text>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>