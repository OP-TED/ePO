<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : TEDXSD_to_ePOTTL.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : Transformation from TED XSD to ePO TTL
    ####################################################################################
    -->    
    
    <xsl:import href="common/AwardCriterion.xsl"/>
    <xsl:import href="common/AwardResult.xsl"/>
    <xsl:import href="common/ccts.xsl"/>
    <xsl:import href="common/CommonFunctions.xsl"/>
    <xsl:import href="common/Contract.xsl"/>
    <xsl:import href="common/ContractAwardNotice.xsl"/>
    <xsl:import href="common/Criterion.xsl"/>
    <xsl:import href="common/EconomicOperator.xsl"/>
    <xsl:import href="common/EvaluationResult.xsl"/>
    <xsl:import href="common/Lots.xsl"/>
    <xsl:import href="common/Organization.xsl"/>
    <xsl:import href="common/ProcurementProcedure.xsl"/>
    <xsl:import href="common/ProcurementProject.xsl"/>
    <xsl:import href="common/ProcurementValue.xsl"/>
    <xsl:import href="common/ProcuringEntity.xsl"/>
    <xsl:import href="common/SelectionCriterion.xsl"/>
    <xsl:import href="common/Simple_classes.xsl"/>

    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:result-document method="text" href="../output/SPARQL_Inserts-{ted:TED_EXPORT/@DOC_ID}.txt">
            <xsl:call-template name="prefixes"/>
            
            <xsl:call-template name="contract_award_notice"/>
            
            <xsl:apply-templates select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]/child::*"/>      
            
            <xsl:if test="not(exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE))">
                <xsl:call-template name="ProcurementProcedure"/>
            </xsl:if>
            <!-- :EvaluationResult individual -->
            <xsl:call-template name="EvaluationResult"/>
            <xsl:call-template name="EvaluationBoard"/>      
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="ted:NOTICE_UUID"/>
    <xsl:template match="ted:TECHNICAL_SECTION"/>
    <xsl:template match="ted:LINKS_SECTION"/>
    <xsl:template match="ted:CODED_DATA_SECTION"/>
    <xsl:template match="ted:TRANSLATION_SECTION"/>
    <xsl:template match="ted:OBJECT_CONTRACT[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:OBJECT_CONTRACT[parent::*/@CATEGORY = 'ORIGINAL']">
        <xsl:apply-templates select="ted:OBJECT_DESCR"/>
    </xsl:template>
    <xsl:template match="ted:LEFTI[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:COMPLEMENTARY_INFO"/>
    <xsl:template match="ted:CONTRACTING_BODY[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:PROCEDURE[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:AWARD_CONTRACT[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:RESULTS[parent::*/@CATEGORY != 'ORIGINAL']"/>
    <xsl:template match="ted:MODIFICATIONS_CONTRACT"/>
    <xsl:template match="ted:CHANGES"/>
</xsl:stylesheet>