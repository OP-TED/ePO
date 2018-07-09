<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : AwardResult.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :AwardResult from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :hasAwardResult :AwardResult -->
    <xsl:template name="hasAwardResult">
        <xsl:param name="award_id"/>
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasAwardResult :AwardRes_', $award_id, '_', $identifier, ';')"/>
        </xsl:call-template>
    </xsl:template>
        
    <!-- :AwardResult individual -->
    <xsl:template name="AwardResult">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':AwardRes_', parent::*[1]/@ITEM, '_', $identifier, ' rdf:type :AwardResult;')"/>
        </xsl:call-template>
        
        <!-- :AwardResult :hasAwardedContractQuantity 1 -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasAwardedContractQuantity 1;'"/>
        </xsl:call-template>
        
        <!-- :AwardResult :isReferredByAContract :Contract -->
        <xsl:call-template name="isReferredByAContract"/>
        
        <!-- :AwardResult :hasAwardResultDateOfConclusion xsd:Date -->
        <xsl:apply-templates select="ted:DATE_CONCLUSION_CONTRACT"/>
        
        <!-- :AwardResult :hasWinner :Winner -->
        <xsl:apply-templates select="ted:NO_AWARDED_TO_GROUP, ted:AWARDED_TO_GROUP"/>
        
        <!-- :AwardResult :aggregatesProcurementStatistics :ProcedureStatistics -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':aggregatesProcurementStatistics :ProcStats_', parent::*[1]/@ITEM, '_', $identifier, ' ;')"/>
        </xsl:call-template>
        
        <xsl:call-template name="end_triple"/>
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <xsl:call-template name="create_procurementStatistics">
            <xsl:with-param name="individual" select="concat(':ProcStats_', parent::*[1]/@ITEM, '_', $identifier)"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcedureStatistics individual -->
    <xsl:template name="create_procurementStatistics">
        <xsl:param name="individual"/>
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat($individual, ' rdf:type :ProcedureStatistics ;')"/>
        </xsl:call-template>
        
        <!-- :ProcedureStatistics :hasEEAReceivedTenders xsd:nonNegativeInteger -->
        <xsl:if test="exists(ted:NB_TENDERS_RECEIVED_OTHER_EU)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEEAReceivedTenders ', ted:NB_TENDERS_RECEIVED_OTHER_EU, ' ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcedureStatistics :hasEUReceivedTenders xsd:nonNegativeInteger -->
        <xsl:if test="exists(ted:NB_TENDERS_RECEIVED)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEUReceivedTenders ', ted:NB_TENDERS_RECEIVED, ' ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcedureStatistics :hasNonEUReceivedTenders xsd:nonNegativeInteger -->
        <xsl:if test="exists(ted:NB_TENDERS_RECEIVED_NON_EU)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasNonEUReceivedTenders ', ted:NB_TENDERS_RECEIVED_NON_EU, ' ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcedureStatistics :hasEMeansReceivedTenders xsd:nonNegativeInteger -->
        <xsl:if test="exists(ted:NB_TENDERS_RECEIVED_EMEANS)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEMeansReceivedTenders ', ted:NB_TENDERS_RECEIVED_EMEANS, ' ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcedureStatistics :hasSMEReceivedTenders xsd:nonNegativeInteger -->
        <xsl:if test="exists(ted:NB_TENDERS_RECEIVED_SME)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasSMEReceivedTenders ', ted:NB_TENDERS_RECEIVED_SME, ' ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="end_triple"/>
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :AwardResult :hasWinner :Winner -->
    <xsl:template match="ted:NO_AWARDED_TO_GROUP">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasWinner :WEO_', parent::*[1]/parent::*[1]/@ITEM, '_', $identifier, ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :AwardResult :hasWinner :Winner -->
    <xsl:template match="ted:AWARDED_TO_GROUP">
        <xsl:variable name="winner_quantity" select="count(parent::*/ted:CONTRACTOR)"/>
        <xsl:variable name="item_id" select="parent::*[1]/parent::*[1]/@ITEM"/>
        <xsl:for-each select="0 to (xs:integer($winner_quantity)-1)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasWinner :WEOG_', ., '_', $item_id, '_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :AwardResult individual (when Procurement Regime is Design Contest) -->
    <xsl:template name="AwardResult_DesignContest">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':AwardRes_', $identifier, ' rdf:type :AwardResult;')"/>
        </xsl:call-template>
        
        <!-- :AwardResult :isReferredByAContract :Contract -->
        <xsl:call-template name="isReferredByAContract_DesignContest"/>
        
        <!-- :AwardResult :hasAwardResultDateOfConclusion xsd:Date -->
        <xsl:apply-templates select="ted:DATE_DECISION_JURY"/>
        
        <!-- :AwardResult :hasWinner :Winner -->
        <xsl:variable name="winner_quantity" select="count(ted:WINNER)"/>
        <xsl:for-each select="0 to (xs:integer($winner_quantity)-1)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasWinner :WEO_', ., '_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:for-each>
        
        <xsl:call-template name="end_triple"/>
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :AwardResult :hasAwardResultDateOfConclusion xsd:Date -->
    <xsl:template match="ted:DATE_DECISION_JURY | ted:DATE_CONCLUSION_CONTRACT">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasAwardResultDateOfConclusion &quot;', ., 'T00:00:00&quot;^^xsd:dateTime', ';')"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>