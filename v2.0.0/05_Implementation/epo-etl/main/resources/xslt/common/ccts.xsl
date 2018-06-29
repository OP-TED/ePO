<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ccts.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : CCTS ontology from CCTS
    ####################################################################################
    -->
    
    <!-- ccts:Identifier individual -->
    <xsl:template name="ccts_identifier"> 
        <xsl:param name="individual"/>
        <xsl:param name="value"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat($individual,' rdf:type ccts:Identifier ;')"/>
        </xsl:call-template>
        
        <!-- ccts:Identifier ccts:identifierValue xsd:normalizedString -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('ccts:identifierValue &quot;', xs:normalizedString($value),'&quot; ;')"/>
        </xsl:call-template>
        
        <!-- ccts:Identifier ccts:schemeAgencyID xsd:normalizedString -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="'ccts:schemeAgencyID &quot;eu.europa.publicationsoffice.epo&quot; ;'"/>
        </xsl:call-template>
        
        <xsl:call-template name="end_triple"/>  
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
</xsl:stylesheet>