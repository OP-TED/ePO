<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Criterion.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :Criterion, :CriterionProperty, :CriterionPropertyGroup from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <xsl:template match="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI">
        <!-- Selection Criterion -->
        <xsl:apply-templates select="ted:SUITABILITY, 
            ted:ECONOMIC_CRITERIA_DOC, ted:ECONOMIC_FINANCIAL_INFO, ted:ECONOMIC_FINANCIAL_MIN_LEVEL,
            ted:TECHNICAL_CRITERIA_DOC, ted:TECHNICAL_PROFESSIONAL_INFO, ted:TECHNICAL_PROFESSIONAL_MIN_LEVEL,
            ted:QUALIFICATION/ted:CONDITIONS, ted:QUALIFICATION/ted:METHODS, 
            ted:PARTICULAR_PROFESSION, ted:REFERENCE_TO_LAW,
            ted:PERFORMANCE_CONDITIONS, ted:PERFORMANCE_STAFF_QUALIFICATION,
            ted:CRITERIA_SELECTION"/>
        
        <!-- Exclusion Criterion -->
        <xsl:apply-templates select="ted:RULES_CRITERIA"/>
    </xsl:template>
    
    <xsl:template match="ted:RULES_CRITERIA">
        <!-- :Criterion individual -->        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Criterion_', count(following-sibling::*), '_', $identifier, ' rdf:type :ExclusionGrounds;')"/>
        </xsl:call-template>
        
        <!-- :Criterion :usesCriterionTaxonomy :CriterionTaxonomy -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.EXCLUSION ;'"/>
        </xsl:call-template>
        
        <!-- :Criterion :hasCriterionDescription xsd:String -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasCriterionDescription &quot;', replace(., '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
        
        <!-- :Criterion :hasCriterionPropertyGroup :CriterionPropertyGroup -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasCriterionPropertyGroup :CriterionPG_', count(following-sibling::*), '_', $identifier, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :CriterionPropertyGroup individual -->
        <xsl:call-template name="criterionPropertyGroup">
            <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $identifier)"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :CriterionPropertyGroup individual -->
    <xsl:template name="criterionPropertyGroup">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':CriterionPG_', $individual_id, ' rdf:type :CriterionPropertyGroup;')"/>
        </xsl:call-template>
        
        <!-- :CriterionPropertyGroup :hasCriterionProperty :CriterionProperty -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasCriterionProperty :CriterionP_', $individual_id, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :CriterionProperty individual -->
        <xsl:call-template name="CriterionProperty">
            <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $identifier)"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :CriterionProperty individual -->
    <xsl:template name="CriterionProperty">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':CriterionP_', $individual_id, ' rdf:type :CriterionProperty;')"/>
        </xsl:call-template>
        
        <!-- :CriterionProperty :hasCriterionPropertyDescription xsd:String -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasCriterionPropertyDescription &quot;Please describe them.&quot;.'"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
    <!-- :TenderEvaluationTerms :definesCriterion :Criterion -->
    <xsl:template name="definesCriterion">
        <xsl:variable name="lefti" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:LEFTI/child::*"/>
        
        <xsl:for-each select="$lefti">
            <xsl:variable name="lefti_id" select="count(following-sibling::*)"/>
            
            <xsl:if test="name()='RULES_CRITERIA'">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':definesCriterion :Criterion_', $lefti_id, '_', $identifier,  ' ;')"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="name()='SUITABILITY' or name()='ECONOMIC_FINANCIAL_INFO' or name()='ECONOMIC_FINANCIAL_MIN_LEVEL' or name()='TECHNICAL_PROFESSIONAL_INFO' or name()='TECHNICAL_PROFESSIONAL_MIN_LEVEL'
                or name()='REFERENCE_TO_LAW' or name()='PERFORMANCE_CONDITIONS' or name()='CRITERIA_SELECTION' or name()='QUALIFICATION' or name()='ECONOMIC_CRITERIA_DOC' or name()='TECHNICAL_CRITERIA_DOC'
                or name()='PERFORMANCE_STAFF_QUALIFICATION' or name()='PARTICULAR_PROFESSION'">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':definesCriterion :SelectionCr_', $lefti_id, '_', $identifier,  ' ;')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>