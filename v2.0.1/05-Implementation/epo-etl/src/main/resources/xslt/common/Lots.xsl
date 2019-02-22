<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Lots.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : OBJECT_CONTRACT from TED to :Lot from ePO
    ####################################################################################
    -->
    
    <!-- :ProcurementProcedure :includesLot :Lot -->
    <xsl:template name="includesLot">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        
        <xsl:for-each select="$object_contract/ted:OBJECT_DESCR">
            <xsl:variable name="last" select="count(following-sibling::*)"/>
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="if($last=0) then(concat(':includesLot :Lot_', @ITEM, '_', $identifier,' .')) else(concat(':includesLot :Lot_', @ITEM, '_', $identifier,' ;'))"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :Lot individual -->
    <xsl:template match="ted:OBJECT_DESCR">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Lot_', @ITEM, '_', $identifier, ' rdf:type :Lot;')"/>
        </xsl:call-template>
        
        <!-- :Lot :hasPurpose :Purpose -->
        <xsl:if test="exists(ted:OPTIONS) or exists(ted:NO_OPTIONS) or exists(ted:OPTIONS_DESCR) or exists(ted:NUTS) or exists(n2016:NUTS) or exists(ted:DATE_START) or exists(ted:DATE_END) or exists(ted:DURATION) or exists(ted:CPV_ADDITIONAL)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasPurpose :PurpL_', @ITEM, '_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Lot :hasEstimatedProcurementValue :ProcurementValue -->
        <xsl:if test="exists(ted:VAL_OBJECT)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEstimatedProcurementValue :EstPVL_', @ITEM, '_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Lot :hasFundsIdentification :FundsIdentification -->
        <xsl:if test="exists(ted:EU_PROGR_RELATED) or exists(ted:NO_EU_PROGR_RELATED)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasFundsIdentification :FundsL_', @ITEM, '_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates select="ted:TITLE, ted:SHORT_DESCR"/>
        
        <!-- :Lot :belongsToProcurementProcedure :ProcurementProcedure -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':belongsToProcurementProcedure :PProc', string($identifier),'.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- Individuals :Purpose :ProcurementValue :FundsIdentification -->
        <xsl:call-template name="ProcurementProject_LotHasPurpose"/>        
        <xsl:call-template name="ProcurementProject_LotEstimatedProcValue"/>        
        <xsl:call-template name="ProcurementProject_LotFunds"/>
        
        <!-- :AwardCriterion individuals -->
        <xsl:apply-templates select="ted:AC_PROCUREMENT_DOC, ted:AC_QUALITY, ted:AC_COST, ted:AC_PRICE"/>
    </xsl:template>
</xsl:stylesheet>