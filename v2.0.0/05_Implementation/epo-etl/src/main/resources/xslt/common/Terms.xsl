<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Terms.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :FinancialTerms, :SubcontractTerms, :TenderSubmissionTerms, :NotificationTerms, :ContractTerms, :TenderEvaluationTerms, :PostAwardImplementationTerms from ePO
    ####################################################################################
    -->
    
    <xsl:template name="Terms">        
        <!-- :ReviewTerms individual -->
        <xsl:call-template name="ReviewTerms"/>
        
        <!-- :AwardTerms individual -->
        <xsl:call-template name="AwardTerms"/>
        
        <!-- :FinancialTerms individual -->
        <!--xsl:call-template name="FinancialTerms"/-->
        
        <!-- :TenderSubmissionTerms individual -->
        <xsl:call-template name="SubmissionTerms"/>        
        
        <!-- :NotificationTerms individual -->
        <!--xsl:call-template name="NotificationTerms"/-->
        
        <!-- :ContractTerms individual -->
        <xsl:call-template name="ContractTerms"/>
        
        <!-- :TenderEvaluationTerms individual -->
        <xsl:call-template name="TenderEvaluationTerms"/>
    </xsl:template>
    
    <!-- :ReviewTerms individual -->
    <xsl:template name="ReviewTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="complementary_info" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:COMPLEMENTARY_INFO"/>
        
        <xsl:if test="exists($complementary_info/ted:REVIEW_PROCEDURE) or exists($complementary_info/ted:ADDRESS_REVIEW_BODY) or exists($complementary_info/ted:ADDRESS_MEDIATION_BODY) or exists($complementary_info/ted:ADDRESS_REVIEW_INFO)">
            
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':ReviewTerms_', $identifier, ' rdf:type :ReviewTerms;')"/>
            </xsl:call-template>
            
            <!-- :ProcedureTerms :reviewDeadlineDescription xsd:String -->
            <xsl:if test="exists($complementary_info/ted:REVIEW_PROCEDURE)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasReviewProcedure &quot;', replace($complementary_info/ted:REVIEW_PROCEDURE, '&quot;', '”'),'&quot; ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ProcedureTerms :hasReviewOrganisation org:Organization -->
            <xsl:if test="exists($complementary_info/ted:ADDRESS_REVIEW_BODY)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasReviewOrganisation :ReviewOrg_', $identifier,' ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ProcedureTerms :hasMediationOrganisation org:Organization -->
            <xsl:if test="exists($complementary_info/ted:ADDRESS_MEDIATION_BODY)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasMediationOrganisation :MedOrg_', $identifier,' ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ProcedureTerms :hasReviewService org:Organization -->
            <xsl:if test="exists($complementary_info/ted:ADDRESS_REVIEW_INFO)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasReviewService :ReviewServ_', $identifier,' ;')"/>
                </xsl:call-template>
            </xsl:if>            
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
        </xsl:if>
        
        <xsl:if test="exists($complementary_info/ted:ADDRESS_REVIEW_BODY)">
            <xsl:call-template name="createOrganization">
                <xsl:with-param name="value" select="$complementary_info/ted:ADDRESS_REVIEW_BODY"/>
                <xsl:with-param name="individual" select="concat('ReviewOrg_', $identifier)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="exists($complementary_info/ted:ADDRESS_MEDIATION_BODY)">
            <xsl:call-template name="createOrganization">
                <xsl:with-param name="value" select="$complementary_info/ted:ADDRESS_MEDIATION_BODY"/>
                <xsl:with-param name="individual" select="concat('MedOrg_', $identifier)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="exists($complementary_info/ted:ADDRESS_REVIEW_INFO)">
            <xsl:call-template name="createOrganization">
                <xsl:with-param name="value" select="$complementary_info/ted:ADDRESS_REVIEW_INFO"/>
                <xsl:with-param name="individual" select="concat('ReviewServ_', $identifier)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :AwardTerms individual -->
    <xsl:template name="AwardTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="maxAwardedLot" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_MAX_ONE_TENDERER"/>
        
        <xsl:if test="exists($maxAwardedLot)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':AwardTerms_', $identifier, ' rdf:type :AwardTerms;')"/>
            </xsl:call-template>
            <!-- :AwardTerms :hasMaxLotsAwarded xsd:nonNegativeIntegere -->
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasMaxLotsAwarded ', $maxAwardedLot, ' .')"/>
            </xsl:call-template>
            
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
        </xsl:if>
    </xsl:template>
    
    <!-- :FinancialTerms individual -->
    <xsl:template name="FinancialTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="lefti" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI"/>
        
        <!--xsl:if test="exists($lefti/ted:ECONOMIC_FINANCIAL_INFO) or exists($lefti/ted:DEPOSIT_GUARANTEE_REQUIRED)"-->
        <xsl:if test="exists($lefti/ted:ECONOMIC_FINANCIAL_INFO)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':FTerms_', $identifier, ' rdf:type :FinancialTerms;')"/>
            </xsl:call-template>
            <!-- :FinancialTerms :hasFinancialConditions xsd:String -->
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasFinancialConditions &quot;', replace($lefti/ted:ECONOMIC_FINANCIAL_INFO, '&quot;', '”'),'&quot;.')"/>
            </xsl:call-template>
            
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->   
        </xsl:if>
    </xsl:template>
    
    <!-- :TenderSubmissionTerms individual -->
    <xsl:template name="SubmissionTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="procedure" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE"/>
        <xsl:variable name="lot_max_number" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_MAX_NUMBER"/>
        <xsl:variable name="lot_only" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:LOT_DIVISION/ted:LOT_ONE_ONLY"/>
        
        <xsl:if test="exists($procedure/ted:LANGUAGES) or exists($procedure/ted:DATE_TENDER_VALID) or exists($procedure/ted:DURATION_TENDER_VALID) or exists($lot_max_number) or exists($lot_only)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':TSTerms_', $identifier, ' rdf:type :TenderSubmissionTerms ;')"/>
            </xsl:call-template>
            
            <!-- :TenderSubmissionTerms :maxAllowedLots epo-rd:BidType -->
            <xsl:if test="exists($lot_only)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':maxAllowedLots epo-rd:LOT_ONE ;'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="exists($lot_max_number)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':maxAllowedLots epo-rd:LOT_ONE_MORE ;'"/>
                </xsl:call-template>
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasLotMaxNumber ', $lot_max_number, ' ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :TenderSubmissionTerms :hasValidityDeadline ccts:Date -->
            <xsl:if test="exists($procedure/ted:DATE_TENDER_VALID)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasValidityDeadline &quot;', $procedure/ted:DATE_TENDER_VALID,'&quot;^^xsd:dateTime ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :TenderSubmissionTerms :hasSubmissionDeadline ccts:Date -->
            <xsl:if test="exists($procedure/ted:DATE_RECEIPT_TENDERS) or exists($procedure/ted:TIME_RECEIPT_TENDERS)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasSubmissionDeadline &quot;', $procedure/ted:DATE_RECEIPT_TENDERS, 'T', $procedure/ted:TIME_RECEIPT_TENDERS,'&quot;^^xsd:dateTime ;')"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:for-each select="$procedure/ted:LANGUAGES/ted:LANGUAGE">
                <xsl:variable name="last" select="count(following-sibling::*)"/>
                
                <!-- :TenderSubmissionTerms :hasSubmissionLanguage LanguageType -->
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="if($last=0) then(concat(':hasSubmissionLanguage :', @VALUE,'.')) else(concat(':hasSubmissionLanguage :', @VALUE,';'))"/>
                </xsl:call-template>
            </xsl:for-each>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->               
        </xsl:if>
    </xsl:template>
    
    <!-- :NotificationTerms individual -->
    <xsl:template name="NotificationTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="procedure" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE"/>
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        
        <xsl:if test="exists($procedure/ted:DATE_DISPATCH_INVITATIONS) or exists($object_contract/ted:DATE_PUBLICATION_NOTICE)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':NTerms_', $identifier, ' rdf:type :NotificationTerms;')"/>
            </xsl:call-template>
            
            <!-- :NotificationTerms :hasContractNoticePublicationDate ccts:Date -->
            <xsl:if test="exists($object_contract/ted:DATE_PUBLICATION_NOTICE)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="if(exists($procedure/ted:DATE_DISPATCH_INVITATIONS)) then(concat(':hasContractNoticePublicationDate &quot;', $object_contract/ted:DATE_PUBLICATION_NOTICE,'&quot;^^xsd:dateTime ;')) else(concat(':hasContractNoticePublicationDate &quot;', $object_contract/ted:DATE_PUBLICATION_NOTICE,'&quot;^^xsd:dateTime.'))"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :NotificationTerms :hasInvitationDispatchDate ccts:Date -->
            <xsl:if test="exists($procedure/ted:DATE_DISPATCH_INVITATIONS)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasContractNoticePublicationDate &quot;', $procedure/ted:DATE_DISPATCH_INVITATIONS,'&quot;^^xsd:dateTime.')"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->     
        </xsl:if>
    </xsl:template>
    
    <!-- :ContractTerms individual -->
    <xsl:template name="ContractTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="existsRenewal" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:RENEWAL) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:NO_RENEWAL)"/>
        <xsl:variable name="existsReservedContract" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:RESTRICTED_SHELTERED_WORKSHOP) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:RESTRICTED_SHELTERED_PROGRAM)"/>
        <xsl:variable name="existsPerformanceCountry" select="exists(//ted:CODIF_DATA/n2016:PERFORMANCE_NUTS) or exists(//ted:CODIF_DATA/ted:PERFORMANCE_NUTS)"/>
        <xsl:variable name="complementary_info" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:COMPLEMENTARY_INFO"/>
        
        <xsl:if test="$existsRenewal or $existsReservedContract or $existsPerformanceCountry or exists($complementary_info/ted:EORDERING) or exists($complementary_info/ted:EPAYMENT)">            
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':CTerms_', $identifier, ' rdf:type :ContractTerms;')"/>
            </xsl:call-template>
            
            <!-- :ContractTerms :hasReservedContract ReservedContract -->
            <xsl:if test="$existsReservedContract">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasReservedContract '"/>
                    <xsl:with-param name="object" select="if(exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:RESTRICTED_SHELTERED_WORKSHOP)) then(':SW') else(':SE')"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ContractTerms :hasMaximumNumberRenewals xsd:Decimal -->
            <xsl:if test="$existsRenewal">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasMaximumNumberRenewals '"/>
                    <xsl:with-param name="object" select="if(exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:RENEWAL)) then(number(1)) else(number(0))"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ContractTerms :hasDeliveryCountry CountryType -->
            <xsl:if test="$existsPerformanceCountry">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasDeliveryCountry'"/>
                    <xsl:with-param name="object" select="if(exists(//ted:CODIF_DATA/n2016:PERFORMANCE_NUTS)) then(concat('epo-rd:', //ted:CODIF_DATA/n2016:PERFORMANCE_NUTS)) else(concat('epo-rd:', //ted:CODIF_DATA/ted:PERFORMANCE_NUTS))"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ContractTerms :hasEOrdering xsd:Boolean -->
            <xsl:if test="exists($complementary_info/ted:EORDERING)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':hasEOrdering true;'"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :ContractTerms :hasEPayment xsd:Boolean -->
            <xsl:if test="exists($complementary_info/ted:EPAYMENT)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':hasEPayment true;'"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
        </xsl:if>
    </xsl:template>
    
    <!-- :TenderEvaluationTerms individual -->
    <xsl:template name="TenderEvaluationTerms">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="existsJuryDecision" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:DECISION_BINDING_CONTRACTING) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:NO_DECISION_BINDING_CONTRACTING)"/>
        <xsl:variable name="existsPerfStaff" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/ted:PERFORMANCE_STAFF_QUALIFICATION)"/>
        <xsl:variable name="existsReduction" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:REDUCTION_RECOURSE)"/>
        <xsl:variable name="existsVariants" select="exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:ACCEPTED_VARIANTS) or exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:NO_ACCEPTED_VARIANTS)"/>
        
        
        <xsl:if test="$existsJuryDecision or $existsPerfStaff or $existsReduction or $existsVariants">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':TETerms_', $identifier, ' rdf:type :TenderEvaluationTerms;')"/>
            </xsl:call-template>
            
            <!-- :TenderEvaluationTerms :hasJuryDecisionBinding xsd:Boolean -->
            <xsl:if test="$existsJuryDecision">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasJuryDecisionBinding'"/>
                    <xsl:with-param name="object" select="if(exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:PROCEDURE/ted:DECISION_BINDING_CONTRACTING)) then(true()) else(false())"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :TenderEvaluationTerms :hasPerformingStaffQualification xsd:Boolean -->
            <xsl:if test="$existsPerfStaff">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasPerformingStaffQualification'"/>
                    <xsl:with-param name="object" select="true()"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :TenderEvaluationTerms :hasSuccessiveReduction xsd:Boolean -->
            <xsl:if test="$existsReduction">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasSuccessiveReduction'"/>
                    <xsl:with-param name="object" select="true()"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <!-- :TenderEvaluationTerms :hasVariants xsd:Boolean -->
            <xsl:if test="$existsVariants">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':hasVariants'"/>
                    <xsl:with-param name="object" select="if(exists(//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT/ted:OBJECT_DESCR/ted:ACCEPTED_VARIANTS)) then(true()) else(false())"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="definesCriterion"/>
            
            <xsl:call-template name="end_triple"/>            
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->     
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>