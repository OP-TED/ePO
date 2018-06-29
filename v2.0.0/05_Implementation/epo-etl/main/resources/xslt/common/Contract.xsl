<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Contract.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : AWARD_CONTRACT from TED to :Contract from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- TED - AWARD_CONTRACT maps to ePO - :Contract -->
    <xsl:template match="ted:AWARD_CONTRACT[parent::*/@CATEGORY = 'ORIGINAL']">
        <xsl:if test="exists(ted:AWARDED_CONTRACT) or exists(ted:NO_AWARDED_CONTRACT)">
            <xsl:call-template name="create_contract">
                <xsl:with-param name="award_item" select="@ITEM"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template name="create_contract">
        <xsl:param name="award_item"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Contract_', $award_item, '_', $identifier, ' rdf:type :Contract;')"/>
        </xsl:call-template>
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':attachesDocument :CAN_', $identifier, ';')"/>
        </xsl:call-template>
        
        <!-- :Contract :hasTitle xsd:String -->
        <xsl:if test="exists(ted:TITLE)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasContractTitle &quot;', replace(ted:TITLE, '&quot;', '”'), '&quot;', ';')"/>
            </xsl:call-template>
        </xsl:if>    
        <!-- :Contract :refersToLot :Lot -->
        <xsl:if test="exists(ted:LOT_NO)">
            <xsl:call-template name="refersToLot">
                <xsl:with-param name="lot_number" select="ted:LOT_NO"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(exists(ted:LOT_NO)) and exists(//ted:NO_LOT_DIVISION)">
            <xsl:call-template name="refersToLot">
                <xsl:with-param name="lot_number" select="1"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Contract :hasContractPurpose :Purpose -->
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        <xsl:if test="exists($object_contract/ted:CPV_MAIN) or exists($object_contract/ted:TYPE_CONTRACT)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasContractPurpose :PurpPP_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates select="ted:AWARDED_CONTRACT"/>
        
        <xsl:if test="not(exists(ted:AWARDED_CONTRACT))">
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->            
        </xsl:if>
        
        <xsl:call-template name="refersToPE"/>
    </xsl:template>
    
    <xsl:template match="ted:AWARDED_CONTRACT">        
        <!-- :Contract :refersToAwardResult :AwardResult -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':refersToAwardResult :AwardRes_', parent::*[1]/@ITEM, '_', $identifier, ';')"/>
        </xsl:call-template>
        
        <!-- :Contract :hasProcurementValue :ProcurementValue-->
        <xsl:if test="exists(ted:VAL_RANGE_TOTAL) or exists(ted:VAL_TOTAL)">            
            <xsl:variable name="lot_num" select="parent::*/ted:LOT_NO"/> 
            
            <xsl:choose>
                <xsl:when test="not($lot_num castable as xs:integer) and contains($lot_num, ',')">
                    <xsl:variable name="first_value" select="substring-before($lot_num,',')"/>
                    
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':hasProcurementValue :PValueContract_', $first_value, '_', $identifier, ';')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':hasProcurementValue :PValueContract_', replace(string($lot_num), '[^a-zA-Z0-9]', ''), '_', $identifier, ';')"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- :Contract :hasFrameworkContract :FrameworkAgreement -->
        <xsl:if test="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:FRAMEWORK)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasFrameworkContract :FWKA_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Contract :refersToSignatoryParty :Winner -->
        <xsl:if test="exists(ted:AWARDED_TO_GROUP)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':refersToSignatoryParty :WEOG_0_', parent::*[1]/@ITEM, '_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="exists(ted:NO_AWARDED_TO_GROUP)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':refersToSignatoryParty :WEO_', parent::*[1]/@ITEM, '_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>
                
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <xsl:call-template name="ProcurementProject_ContractProcValue"/>
        
        <!-- If ted:AWARDED_TO_GROUP, maps with :Winner and the variable groupOf -->
        <xsl:if test="exists(ted:AWARDED_TO_GROUP)">
            <xsl:call-template name="create_EOGroup">
                <xsl:with-param name="award_id" select="parent::*[1]/@ITEM"/>
            </xsl:call-template>
        </xsl:if>
        <!-- If ted:NO_AWARDED_TO_GROUP, maps with :Winner -->
        <xsl:if test="exists(ted:NO_AWARDED_TO_GROUP)">
            <xsl:call-template name="Winner">
                <xsl:with-param name="award_id" select="parent::*[1]/@ITEM"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :AwardResult individual -->
        <xsl:call-template name="AwardResult"/>
    </xsl:template>
    
    <xsl:template name="refersToLot">
        <xsl:param name="lot_number"/>
        <!-- 1, 2, 3, 4 <xsl:for-each select="tokenize(current(), ',')"> -->
        <xsl:choose>
            <xsl:when test="not($lot_number castable as xs:integer) and contains($lot_number, ',')">
                <xsl:variable name="first_value" select="substring-before($lot_number,',')"/>
                
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':refersToLot :Lot_', $first_value, '_', $identifier,';')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':refersToLot :Lot_', replace(string($lot_number), '[^a-zA-Z0-9]', ''), '_', $identifier,';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- TED - RESULTS maps to ePO - :Contract -->
    <xsl:template match="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:RESULTS">
        <xsl:apply-templates select="ted:AWARDED_PRIZE"/>
        
        <xsl:call-template name="EvaluationResult_DesignContest"/>
        <xsl:call-template name="EvaluationBoard_DesignContest"/>
    </xsl:template>
    
    <xsl:template match="ted:AWARDED_PRIZE">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Contract_', $identifier, ' rdf:type :Contract;')"/>
        </xsl:call-template>
        
        <!-- :Contract :refersToSignatoryPartyProcuringEntity :ProcuringEntity -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':refersToSignatoryPartyProcuringEntity :PE', $identifier, ';')"/>
        </xsl:call-template>
        
        <!-- :Contract :hasProcurementValue :ProcurementValue -->
        <xsl:if test="exists(ted:VAL_PRIZE)">  
            <xsl:variable name="lot_num" select="parent::*/ted:LOT_NO"/> 
            
            <xsl:choose>
                <xsl:when test="not($lot_num castable as xs:integer) and contains($lot_num, ',')">
                    <xsl:variable name="first_value" select="substring-before($lot_num,',')"/>
                    
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':hasProcurementValue :PValueContract_', $first_value, '_', $identifier, ';')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':hasProcurementValue :PValueContract_', replace(string($lot_num), '[^a-zA-Z0-9]', ''), '_', $identifier, ';')"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- :Contract :refersToLot :Lot -->
        <xsl:call-template name="refersToLot">
            <xsl:with-param name="lot_number" select="ted:LOT_NO"/>
        </xsl:call-template>
        
        <!-- :Contract :hasContractPurpose :Purpose -->
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        <xsl:if test="exists($object_contract/ted:CPV_MAIN)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasContractPurpose :PurpPP_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Contract :refersToAwardResult :AwardResult -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':refersToAwardResult :AwardRes_', $identifier, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <xsl:call-template name="Contract_DesignContestProcValue"/>
        <xsl:call-template name="AwardResult_DesignContest"/>
        
        
        <xsl:variable name="winner" select="ted:WINNER"/>
        <xsl:for-each select="0 to (count($winner)-1)">
            <xsl:call-template name="Winner_DesignContest">
                <xsl:with-param name="award_id" select="."/>
                <xsl:with-param name="winner" select="$winner[.]"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :AwardResult :isReferredByAContract :Contract -->
    <xsl:template name="isReferredByAContract_DesignContest">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':isReferredByAContract :Contract_', $identifier, ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :AwardResult :isReferredByAContract :Contract -->
    <xsl:template name="isReferredByAContract">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':isReferredByAContract :Contract_', parent::*[1]/@ITEM, '_', $identifier, ';')"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>