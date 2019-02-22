<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ContractAwardNotice.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :ContractAwardNotice from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :ContractAwardNotice individual -->
    <xsl:template name="contract_award_notice">
        <xsl:variable name="publication_date" select="/*[1]/ted:CODED_DATA_SECTION/ted:REF_OJS/ted:DATE_PUB"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':CAN_', $identifier,' rdf:type :ContractAwardNotice ;')"/>
        </xsl:call-template>
        
        <!-- :ContractAwardNotice :hasPublicationDate xsd:dateTime 
            Input format: YYYYMMDD -> Output format: YYYY-MM-DDT00:00:00 -->
        <xsl:variable name="format_date" select="replace(normalize-space($publication_date), '(\d{4})(\d{2})(\d{2})', '$1-$2-$3T00:00:00')"/>
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasPublicationDate &quot;', $format_date,'&quot;^^xsd:dateTime ;')"/>
        </xsl:call-template>
        
        <!-- :ContractAwardNotice :hasDocumentIdentifier ccts:Identifier -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasDocumentIdentifier :CAN_ID_', $identifier, ' ;')"/>
        </xsl:call-template>
        
        <!-- :ContractAwardNotice :hasNegotiatedProcedureJustificationType epo-rd:NegotiatedProcedureJustificationType -->
        <xsl:apply-templates select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:PT_AWARD_CONTRACT_WITHOUT_CALL/ted:D_ACCORDANCE_ARTICLE"/>
        
        <xsl:call-template name="end_triple"/>  
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        
        <!-- ccts:Identifier individual -->
        <xsl:call-template name="ccts_identifier">
            <xsl:with-param name="individual" select="concat(':CAN_ID_', $identifier)"/>
            <xsl:with-param name="value" select="$identifier"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ContractAwardNotice :hasNegotiatedProcedureJustificationType epo-rd:NegotiatedProcedureJustificationType -->
    <xsl:template match="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:PT_AWARD_CONTRACT_WITHOUT_CALL/ted:D_ACCORDANCE_ARTICLE">
        <xsl:for-each select="child::node()">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasNegotiatedProcedureJustificationType epo-rd:', name(), ' ;')"/>
            </xsl:call-template>  
        </xsl:for-each> 
    </xsl:template>
    
</xsl:stylesheet>