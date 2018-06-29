<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcurementProcedureTerms.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :FinancialTerms, :SubcontractTerms, :TenderSubmissionTerms, :NotificationTerms, :ContractTerms, :TenderEvaluationTerms, :PostAwardImplementationTerms from ePO
    ####################################################################################
    -->
    
    <xsl:template name="ProcurementProcedureTermsProperties">        
        
        <!-- :ProcurementProcedure :hasAwardTerms :AwardTerms -->
        <xsl:call-template name="hasAwardTerms"/>
        
        <!-- :ProcurementProcedure :hasFinancialTerms :FinancialTerms -->
        <!--xsl:call-template name="hasFinancialTerms"/-->
        
        <!-- :ProcurementProcedure :hasSubmissionTerms :TenderSubmissionTerms -->
        <xsl:call-template name="hasSubmissionTerms"/>        
        
        <!-- :ProcurementProcedure :hasNotificationTerms :NotificationTerms -->
        <!--xsl:call-template name="hasNotificationTerms"/-->
        
        <!-- :ProcurementProcedure :hasContractTerms :ContractTerms -->
        <xsl:call-template name="hasContractTerms"/>
        
        <!-- :ProcurementProcedure :hasReviewTerms :ReviewTerms -->
        <xsl:call-template name="hasReviewTerms"/>
        
        <!-- :ProcurementProcedure :hasTenderEvaluationTerms :TenderEvaluationTerms -->
        <xsl:call-template name="hasTenderEvaluationTerms"/>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasReviewTerms :ReviewTerms -->
    <xsl:template name="hasReviewTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="complementary_info" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:COMPLEMENTARY_INFO"/>
        
        <xsl:if test="exists($complementary_info/ted:REVIEW_PROCEDURE) or exists($complementary_info/ted:ADDRESS_REVIEW_BODY) or exists($complementary_info/ted:ADDRESS_MEDIATION_BODY) or exists($complementary_info/ted:ADDRESS_REVIEW_INFO)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasReviewTerms :ReviewTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasAwardTerms :AwardTerms -->
    <xsl:template name="hasAwardTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="existsMaxAwardedLot" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_MAX_ONE_TENDERER)"/>
        
        <xsl:if test="$existsMaxAwardedLot">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasAwardTerms :AwardTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasFinancialTerms :FinancialTerms -->
    <xsl:template name="hasFinancialTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="lefti" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI"/>
        
        <!--xsl:if test="exists($lefti/ted:ECONOMIC_FINANCIAL_INFO)"-->
        <xsl:if test="exists($lefti/ted:ECONOMIC_FINANCIAL_INFO)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasFinancialTerms :FTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasSubmissionTerms :TenderSubmissionTerms -->
    <xsl:template name="hasSubmissionTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="procedure" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE"/>
        <xsl:variable name="existsMaxAllowedLot" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_MAX_NUMBER) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_ONE_ONLY)"/>
        
        <xsl:if test="exists($procedure/ted:LANGUAGES) or exists($procedure/ted:DATE_TENDER_VALID) or exists($procedure/ted:DURATION_TENDER_VALID) or $existsMaxAllowedLot">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasSubmissionTerms :TSTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasNotificationTerms :NotificationTerms -->
    <xsl:template name="hasNotificationTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="procedure" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE"/>
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        
        <xsl:if test="exists($procedure/ted:DATE_DISPATCH_INVITATIONS) or exists($object_contract/ted:DATE_PUBLICATION_NOTICE)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasNotificationTerms :NTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasContractTerms :ContractTerms -->
    <xsl:template name="hasContractTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="existsRenewal" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:RENEWAL) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:NO_RENEWAL)"/>
        <xsl:variable name="existsReservedContract" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:RESTRICTED_SHELTERED_WORKSHOP) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:RESTRICTED_SHELTERED_PROGRAM)"/>
        <xsl:variable name="existsPerformanceCountry" select="exists(//ted:CODIF_DATA/n2016:PERFORMANCE_NUTS) or exists(//ted:CODIF_DATA/ted:PERFORMANCE_NUTS)"/>
        <xsl:variable name="exists_eordering" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:COMPLEMENTARY_INFO/ted:EORDERING)"/>
        <xsl:variable name="exists_epayment" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:COMPLEMENTARY_INFO/ted:EPAYMENT)"/>
        
        <xsl:if test="$existsRenewal or $existsReservedContract or $existsPerformanceCountry or $exists_eordering or $exists_epayment">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasContractTerms :CTerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasTenderEvaluationTerms :TenderEvaluationTerms -->
    <xsl:template name="hasTenderEvaluationTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="existsJuryDecision" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:DECISION_BINDING_CONTRACTING) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:NO_DECISION_BINDING_CONTRACTING)"/>
        <xsl:variable name="existsPerfStaff" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:PERFORMANCE_STAFF_QUALIFICATION)"/>
        <xsl:variable name="existsReduction" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:REDUCTION_RECOURSE)"/>
        <xsl:variable name="existsVariants" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:ACCEPTED_VARIANTS) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:NO_ACCEPTED_VARIANTS)"/>
        
        
        <xsl:if test="$existsJuryDecision or $existsPerfStaff or $existsReduction or $existsVariants">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasTenderEvaluationTerms :TETerms_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>