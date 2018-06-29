<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : EvaluationResult.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :EvaluationResult from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :ProcurementProcedure :hasEvaluationResult :EvaluationResult -->
    <xsl:template name="hasEvaluationResult">
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasEvaluationResult :EvaluationRes_', $identifier, ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :EvaluationResult individual -->
    <xsl:template name="EvaluationResult">
        <xsl:variable name="award_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:AWARD_CONTRACT"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EvaluationRes_', $identifier, ' rdf:type :EvaluationResult;')"/>
        </xsl:call-template>
        
        <!-- :EvaluationResult :hasAwardResult :AwardResult -->
        <xsl:for-each select="0 to (count($award_contract))">
            <xsl:variable name="current_num" select="."/>
            <xsl:if test="exists($award_contract[$current_num]/ted:AWARDED_CONTRACT)">
                <xsl:call-template name="hasAwardResult">
                    <xsl:with-param name="award_id" select="$award_contract[$current_num]/@ITEM"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:apply-templates select="$award_contract[$current_num]/ted:NO_AWARDED_CONTRACT/ted:PROCUREMENT_UNSUCCESSFUL, $award_contract[$current_num]/ted:NO_AWARDED_CONTRACT/ted:PROCUREMENT_DISCONTINUED"/>
        </xsl:for-each>
        
        <!-- :EvaluationResult :hasNumberAwardedContract xsd:nonNegativeInteger -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasNumberAwardedContract ', count($award_contract/ted:AWARDED_CONTRACT), ';')"/>
        </xsl:call-template>
        
        <!-- :EvaluationResult :isEvaluatedBy :EvaluationBoard -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':isEvaluatedBy :EvBoard_', $identifier, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :EvaluationResult individual (when Procurement Regime is Design Contest) -->
    <xsl:template name="EvaluationResult_DesignContest">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EvaluationRes_1_', $identifier, ' rdf:type :EvaluationResult;')"/>
        </xsl:call-template>
        
        <xsl:apply-templates select="ted:NO_AWARDED_PRIZE/ted:PROCUREMENT_UNSUCCESSFUL, ted:NO_AWARDED_PRIZE/ted:PROCUREMENT_DISCONTINUED"/>
        
        <!-- :EvaluationResult :hasAwardResult :AwardResult -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasAwardResult :AwardRes_', $identifier, ';')"/>
        </xsl:call-template>
        
        <!-- :EvaluationResult :isEvaluatedBy :EvaluationBoard -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':isEvaluatedBy :EvBoard_', $identifier, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :EvaluationResult :hasNoResultReason xsd:String -->
    <xsl:template match="ted:NO_AWARDED_PRIZE/ted:PROCUREMENT_UNSUCCESSFUL | ted:NO_AWARDED_CONTRACT/ted:PROCUREMENT_UNSUCCESSFUL">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasNoResultReason &quot;No tenders or requests to participate were received or all were rejected.&quot; ;'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :EvaluationResult :hasNoResultReason xsd:String -->
    <xsl:template match="ted:NO_AWARDED_PRIZE/ted:PROCUREMENT_DISCONTINUED | ted:NO_AWARDED_CONTRACT/ted:PROCUREMENT_DISCONTINUED">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasNoResultReason &quot;Discontinuation of procedure.&quot; ;'"/>
        </xsl:call-template>
    </xsl:template>
    
    
    <!-- :EvaluationBoard individual -->
    <xsl:template name="EvaluationBoard">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EvBoard_', $identifier, ' rdf:type :EvaluationBoard;')"/>
        </xsl:call-template>
        
        <!-- :EvaluationBoard :hasEvaluationBoardCodeType :REGULAR -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasEvaluationBoardCodeType :REGULAR.'"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :EvaluationBoard individual (when Procurement Regime is Design Contest) -->
    <xsl:template name="EvaluationBoard_DesignContest">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EvBoard_', $identifier, ' rdf:type :EvaluationBoard;')"/>
        </xsl:call-template>
        
        <!-- :EvaluationBoard :hasEvaluationBoardCodeType :JURY -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasEvaluationBoardCodeType :JURY;'"/>
        </xsl:call-template>
        
        <!-- :EvaluationBoard :hasMember foaf:Person -->
        <xsl:variable name="board_quantity" select="count(ted:MEMBER_NAME)"/>
        <xsl:for-each select="0 to (xs:integer($board_quantity)-1)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasMember :EB_', ., '_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:for-each>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <xsl:apply-templates select="ted:MEMBER_NAME"/>
    </xsl:template>
    
    <!-- foaf:Person individual -->
    <xsl:template match="ted:MEMBER_NAME">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EB_', ., '_', $identifier, ' rdf:type foaf:Person;')"/>
        </xsl:call-template>
        
        <!-- :EvaluationBoard :hasEvaluationBoardCodeType :JURY -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('foaf:firstName &quot;', ., '&quot;')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
</xsl:stylesheet>