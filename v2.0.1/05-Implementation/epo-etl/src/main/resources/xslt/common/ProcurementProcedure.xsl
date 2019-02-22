<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcurementProcedure.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : PROCEDURE from TED to :ProcurementProcedure, a subclass of :ProcurementProject from ePO
    ####################################################################################
    -->  
    <xsl:import href="ProcurementProcedureTerms.xsl"/>
    <xsl:import href="Terms.xsl"/>
    
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- TED - PROCEDURE maps to ePO - :ProcurementProcedure -->
    <xsl:template name="ProcurementProcedure" match="ted:PROCEDURE[parent::*/@CATEGORY = 'ORIGINAL']">
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':PProc', string($identifier), ' rdf:type :ProcurementProcedure;')"/>
        </xsl:call-template>
        
        <xsl:call-template name="ProcurementProject_DataProperties"/>
        <xsl:call-template name="create_PProc_data"/>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
        
        <xsl:call-template name="Terms"/>
        <xsl:call-template name="ProcurementProject_ObjectProperties"/>
        
        <!-- :ProcurementProcedure :hasProcuringEntity :ProcuringEntity -->
        <xsl:call-template name="hasProcuringEntity"/>
        
        <!-- :ProcuringEntity individual -->
        <xsl:variable name="contracting_body" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY"/>
        <xsl:if test="exists($contracting_body/ted:URL_DOCUMENT) or exists($contracting_body/ted:URL_PARTICIPATION)">
            <xsl:call-template name="AccessTool"/>
        </xsl:if>
        
        <xsl:apply-templates select="ted:FRAMEWORK"/>
        <xsl:apply-templates select="ted:DPS, ted:EAUCTION_USED"/>
        
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>    
        
        <!-- ccts:Identifier individual -->
        <xsl:if test="exists($object_contract/ted:REFERENCE_NUMBER)">
            <xsl:call-template name="ccts_identifier">
                <xsl:with-param name="individual" select="concat(':PProc_ID_', $identifier)"/>
                <xsl:with-param name="value" select="$object_contract/ted:REFERENCE_NUMBER"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
        
    <!-- :ProcurementProcedure data properties -->
    <xsl:template name="create_PProc_data">
        <!-- :ProcurementProcedure :hasGuaranteeRequired xsd:boolean -->
        <xsl:variable name="lefti" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI"/>
        <xsl:apply-templates select="$lefti/ted:DEPOSIT_GUARANTEE_REQUIRED"/>
        
        <!-- :ProcurementProcedure :hasProcurementDocument :ContractAwardNotice -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasProcurementDocument :CAN_', $identifier, ' ;')"/>
        </xsl:call-template>
        
        <!-- :ProcurementProcedure :hasAcceleratedProcedureFurtherJustification xsd:string -->
        <xsl:if test="exists(ted:ACCELERATED_PROC)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasAcceleratedProcedureFurtherJustification &quot;', replace(ted:ACCELERATED_PROC, '&quot;', '”'), '&quot;', ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :hasAwardDateScheduled ccts:date -->
        <xsl:if test="exists(ted:DATE_AWARD_SCHEDULED)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasAwardDateScheduled &quot;', ted:DATE_AWARD_SCHEDULED, '&quot;^^xsd:dateTime', ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :hasGPAusage xsd:boolean -->
        <xsl:if test="exists(ted:CONTRACT_COVERED_GPA) or exists(ted:NO_CONTRACT_COVERED_GPA)">
            <xsl:variable name="gpaIndicator" select="if(exists(ted:CONTRACT_COVERED_GPA)) then true() else false()"/>
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasGPAusage ', $gpaIndicator, ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :usesTerminationType epo-rd:TerminationType -->
        <xsl:if test="exists(ted:TERMINATION_DPS)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="':usesTerminationType epo-rd:TERMINATION_DPS ;'"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="exists(ted:TERMINATION_PIN)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="':usesTerminationType epo-rd:TERMINATION_PIN ;'"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :hasProcedureChoiceJustification xsd:string -->
        <xsl:if test="exists(ted:PT_AWARD_CONTRACT_WITHOUT_CALL/ted:D_JUSTIFICATION)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasProcedureChoiceJustification &quot;', replace(ted:PT_AWARD_CONTRACT_WITHOUT_CALL/ted:D_JUSTIFICATION, '&quot;', '”'), '&quot;', ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :hasProcedureMainFeatures xsd:string -->
        <xsl:if test="exists(ted:MAIN_FEATURES_AWARD)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasProcedureMainFeatures &quot;', replace(ted:MAIN_FEATURES_AWARD, '&quot;', '”'), '&quot;', ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProcedure :underProcurementRegime epo-rd:ProcurementRegimeType (F12_2014 is :DESIGN_CONTEST and F21, F22, F23_2014 is :SOCIAL_SPECIFIC_SERVICES -->
        <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014') and @CATEGORY = 'ORIGINAL'][1]/name()"/>
        <xsl:choose>
            <xsl:when test="contains($root_name, 'F12_2014')">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':underProcurementRegime epo-rd::DESIGN_CONTEST;'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($root_name, 'F21_2014') or contains($root_name, 'F22_2014') or contains($root_name, 'F23_2014')">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':underProcurementRegime epo-rd::SOCIAL_SPECIFIC_SERVICES;'"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        
        <xsl:call-template name="getRecurrency"/>
        
        <!-- :ProcurementProcedure :usesProcurementProcedureType epo-rd:ProcurementProcedureType -->
        <xsl:variable name="ted_procedure_type"><xsl:call-template name="getProcurementProcedureType"/></xsl:variable>
        <xsl:if test="not(contains($ted_procedure_type, 'null'))">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':usesProcurementProcedureType ', $ted_procedure_type, ';')"/>
            </xsl:call-template>
        </xsl:if>    
        
        <!-- :ProcurementProcedure :hasDynamicPurchaseSystem :DynamicPurchaseSystem -->
        <xsl:if test="exists(ted:DPS)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasDynamicPurchaseSystem :DPS_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>    
        
        <!-- :ProcurementProcedure :hasEAuction :EAuction -->
        <xsl:if test="exists(ted:EAUCTION_USED)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEAuction :EAuct_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>    
        
        <!-- :ProcurementProcedure all Terms -->
        <xsl:call-template name="ProcurementProcedureTermsProperties"/>
        
        <!-- :ProcurementProcedure :hasEvaluationResult :EvaluationResult -->
        <xsl:variable name="award_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:AWARD_CONTRACT"/>
        <xsl:if test="exists($award_contract)">
            <xsl:call-template name="hasEvaluationResult"/>            
        </xsl:if>
        <xsl:if test="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:RESULTS/ted:AWARDED_PRIZE)">
            <xsl:call-template name="hasEvaluationResult"/>
        </xsl:if>      
        
        <!-- :ProcurementProcedure :hasAccessTool :AccessTool -->
        <xsl:variable name="contracting_body" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY"/>
        <xsl:if test="exists($contracting_body/ted:URL_DOCUMENT) or exists($contracting_body/ted:URL_PARTICIPATION)">
            <xsl:call-template name="hasAccessTool"/>
        </xsl:if>
        
        <!-- :ProcurementProcedure :includesLot :Lot -->
        <xsl:call-template name="includesLot"/>
    </xsl:template>
        
    <!-- :ProcurementProcedure :hasRecurrentIndicator xsd:boolean 
         :ProcurementProcedure :hasRecurrencyDescription xsd:string -->
    <xsl:template name="getRecurrency">
        <xsl:variable name="complementary_info" select="//ted:COMPLEMENTARY_INFO"/>
        
        <xsl:if test="exists($complementary_info/ted:RECURRENT_PROCUREMENT)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasRecurrentIndicator ', true(), ';')"/>
            </xsl:call-template>            
        </xsl:if>
        <xsl:if test="exists($complementary_info/ted:NO_RECURRENT_PROCUREMENT)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasRecurrentIndicator ', false(), ';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="exists($complementary_info/ted:ESTIMATED_TIMING)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasRecurrencyDescription &quot;', replace($complementary_info/ted:ESTIMATED_TIMING, '&quot;', '”'), '&quot; ;')"/>
            </xsl:call-template>            
        </xsl:if>
    </xsl:template>
    
    <!-- Get Procurement Procedure Type according to ted:PROCEDURE -->
    <xsl:template name="getProcurementProcedureType">
        <xsl:variable name="mappingStructure" select="document('MappingStructure.xml')/FORM_SECTION/ProcurementProcedureType"/>
        
        <xsl:choose>
            <xsl:when test="exists(ted:PT_OPEN)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_OPEN']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_RESTRICTED)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_RESTRICTED']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_COMPETITIVE_NEGOTIATION)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_COMPETITIVE_NEGOTIATION']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_COMPETITIVE_DIALOGUE)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_COMPETITIVE_DIALOGUE']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_INNOVATION_PARTNERSHIP)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_INNOVATION_PARTNERSHIP']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_AWARD_CONTRACT_WITHOUT_CALL)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_AWARD_CONTRACT_WITHOUT_CALL']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_NEGOTIATED_WITH_PRIOR_CALL)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_NEGOTIATED_WITH_PRIOR_CALL']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_AWARD_CONTRACT_WITH_PRIOR_PUBLICATION)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_AWARD_CONTRACT_WITH_PRIOR_PUBLICATION']/@epoValue"/></xsl:when>
            <xsl:when test="exists(ted:PT_AWARD_CONTRACT_WITHOUT_PUBLICATION)"><xsl:value-of select="$mappingStructure/section[@tedValue='PT_AWARD_CONTRACT_WITHOUT_PUBLICATION']/@epoValue"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="'null'"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- :ProcurementProcedure :hasGuaranteeRequired xsd:boolean -->
    <xsl:template match="ted:LEFTI/ted:DEPOSIT_GUARANTEE_REQUIRED">
        
    </xsl:template>
    
    <!-- :FrameworkAgreement individual -->
    <xsl:template match="ted:FRAMEWORK">
        <xsl:if test="exists(//ted:AWARDED_CONTRACT)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':FWKA_', $identifier, ' rdf:type :FrameworkAgreement;')"/>
            </xsl:call-template>
            
            <xsl:if test="exists(ted:JUSTIFICATION)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasExtensionJustification &quot;', replace(ted:JUSTIFICATION, '&quot;', '”'), '&quot; ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:apply-templates select="ted:SINGLE_OPERATOR, ted:NB_PARTICIPANTS"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->   
        </xsl:if>
    </xsl:template>
    <xsl:template match="ted:SINGLE_OPERATOR">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasMaximumNumberParticipants 1;'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="ted:NB_PARTICIPANTS">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasMaximumNumberParticipants ', ., ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :DynamicPurchaseSystem individual -->
    <xsl:template match="ted:DPS">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':DPS_', $identifier, ' rdf:type :DynamicPurchaseSystem.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query --> 
    </xsl:template>
    
    <!-- :EAuction individual -->
    <xsl:template match="ted:EAUCTION_USED">
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':EAuct_', $identifier, ' rdf:type :EAuction.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query --> 
    </xsl:template>
    
</xsl:stylesheet>