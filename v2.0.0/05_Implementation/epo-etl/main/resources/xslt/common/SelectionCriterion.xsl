<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : SelectionCriterion.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :SelectionCriterion, :SelectionCriterionProperty, :SelectionCriterionPropertyGroup from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <xsl:template match="ted:SUITABILITY | 
        ted:ECONOMIC_FINANCIAL_INFO | ted:ECONOMIC_FINANCIAL_MIN_LEVEL | 
        ted:TECHNICAL_PROFESSIONAL_INFO | ted:TECHNICAL_PROFESSIONAL_MIN_LEVEL | 
        ted:REFERENCE_TO_LAW | ted:PERFORMANCE_CONDITIONS | ted:CRITERIA_SELECTION">
        
        <xsl:call-template name="selectionCriterion">
            <xsl:with-param name="descr" select="."/>
        </xsl:call-template>  
        
    </xsl:template>
    
    <xsl:template match="ted:QUALIFICATION">
        <xsl:call-template name="selectionCriterion">
            <xsl:with-param name="descr" select="concat(ted:CONDITIONS, ted:METHODS)"/>
        </xsl:call-template>  
    </xsl:template>
    
    <xsl:template match="ted:ECONOMIC_CRITERIA_DOC | ted:TECHNICAL_CRITERIA_DOC">
        <xsl:call-template name="selectionCriterion">
            <xsl:with-param name="descr" select="'Selection criteria as stated in the procurement documents.'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="ted:PERFORMANCE_STAFF_QUALIFICATION">
        <xsl:call-template name="selectionCriterion">
            <xsl:with-param name="descr" select="'Obligation to indicate the names and professional qualifications of the staff assigned to performing the contract.'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="ted:PARTICULAR_PROFESSION">
        <xsl:choose>
            <xsl:when test="exists(@CTYPE)">
                <xsl:call-template name="selectionCriterion">
                    <xsl:with-param name="descr" select="'Execution of the service is reserved to a particular profession.'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="selectionCriterion">
                    <xsl:with-param name="descr" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- :SelectionCriterion individual -->
    <xsl:template name="selectionCriterion">
        <xsl:param name="descr"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':SelectionCr_', count(following-sibling::*), '_', $identifier, ' rdf:type :SelectionCriterion;')"/>
        </xsl:call-template>
        
        <!-- :SelectionCriterion :usesCriterionTaxonomy :CriterionTaxonomy -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.SELECTION ;'"/>
        </xsl:call-template>
        
        <!-- :SelectionCriterion :hasCriterionDescription xsd:String -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasCriterionDescription &quot;', replace($descr, '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
        
        <!-- :SelectionCriterion :hasSelectionCriterionPropertyGroup :SelectionCriterionPropertyGroup -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasSelectionCriterionPropertyGroup :SelectionCrPG_', count(following-sibling::*), '_', $identifier, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :SelectionCriterionPropertyGroup individual -->
        <xsl:call-template name="selectionCriterionPropertyGroup">
            <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $identifier)"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <!-- :SelectionCriterionPropertyGroup individual -->
    <xsl:template name="selectionCriterionPropertyGroup">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':SelectionCrPG_', $individual_id, ' rdf:type :SelectionCriterionPropertyGroup;')"/>
        </xsl:call-template>
        
        <!-- :SelectionCriterionPropertyGroup :hasSelectionCriterionProperty :SelectionCriterionProperty -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasSelectionCriterionProperty :SelectionCrP_', $individual_id, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :selectionCriterionProperty individual -->
        <xsl:call-template name="selectionCriterionProperty">
            <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $identifier)"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :SelectionCriterionProperty individual -->
    <xsl:template name="selectionCriterionProperty">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':SelectionCrP_', $individual_id, ' rdf:type :SelectionCriterionProperty;')"/>
        </xsl:call-template>
        
        <!-- :SelectionCriterionProperty :hasCriterionPropertyDescription xsd:String -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasCriterionPropertyDescription &quot;Please describe them.&quot;.'"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
</xsl:stylesheet>