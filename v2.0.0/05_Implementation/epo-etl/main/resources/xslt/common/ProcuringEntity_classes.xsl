<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Procuringentity_classes.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : ADDRESS_CONTRACTING_BODY/URL_BUYER from TED to :BuyerProfile from ePO;
    #                CONTRACTING_BODY/URL_DOCUMENT and URL_PARTICIPATION from TED to :AccessTool from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :ProcuringEntity :hasBuyerProfile :BuyerProfile -->
    <xsl:template match="ted:ADDRESS_CONTRACTING_BODY/ted:URL_BUYER">
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="':hasBuyerProfile'"/>
            <xsl:with-param name="object" select="concat(':BP', $identifier)"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :BuyerProfile individual and data property -->
    <xsl:template name="BuyerProfile">        
        <xsl:variable name="url_buyer" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY/ted:ADDRESS_CONTRACTING_BODY/ted:URL_BUYER"/>
        
        <!-- :BuyerProfile individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="concat(':BP', $identifier)"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="':BuyerProfile'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        <!-- :BuyerProfile :hasURI -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="':hasURI'"/>
            <xsl:with-param name="object" select="concat('&quot;', $url_buyer, '&quot;')"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>        
    </xsl:template>
    
    <!-- :ProcuringEntity :hasAccessTool :AccessTool -->
    <xsl:template name="hasAccessTool">        
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="':hasAccessTool'"/>
            <xsl:with-param name="object" select="concat(':AT', $identifier)"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>        
    </xsl:template>
    
    <!-- :AccessTool individual and data property -->
    <xsl:template name="AccessTool">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        
        <xsl:variable name="contracting_body" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <!-- :AccessTool individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="concat(':AT', $identifier)"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="':AccessTool'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        <!-- :AccessTool :hasProcurementDocuments -->
        <xsl:if test="exists($contracting_body/ted:URL_DOCUMENT)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':hasProcurementDocuments'"/>
                <xsl:with-param name="object" select="concat('&quot;', $contracting_body/ted:URL_DOCUMENT, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
            
            <xsl:if test="exists($contracting_body/ted:ADDRESS_PARTICIPATION_IDEM)">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasTendersSubmission'"/>
                    <xsl:with-param name="object" select="concat('&quot;', $contracting_body/ted:URL_DOCUMENT, '&quot;')"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <!-- :AccessTool :hasTendersSubmission -->
        <xsl:if test="exists($contracting_body/ted:URL_PARTICIPATION) and not(exists($contracting_body/ted:ADDRESS_PARTICIPATION_IDEM))">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':hasTendersSubmission'"/>
                <xsl:with-param name="object" select="concat('&quot;', $contracting_body/ted:URL_PARTICIPATION, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="end_triple"/>
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
    </xsl:template>
</xsl:stylesheet>