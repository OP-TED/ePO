<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : AwardCriterion.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :AwardCriterion, :AwardCriterionProperty, :AwardCriterionPropertyGroup from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    <xsl:variable name="award_criteria_type" select="//ted:AC_AWARD_CRIT/@CODE"/>
     
    <!-- :AwardCriterion :usesCriterionTaxonomy :CriterionTaxonomy -->
    <xsl:template name="AwardCriteriaType">
        <xsl:choose>
            <xsl:when test="$award_criteria_type = 1"><!-- lowest price -->
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.AWARD.LOWEST;'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$award_criteria_type = 2"><!-- most economic -->
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.AWARD.MOST_ECONOMIC_TENDER;'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$award_criteria_type = 3"><!-- mixed -->
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.AWARD.MIXED;'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$award_criteria_type = 8"><!-- other -->
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="'epo-rd:usesCriterionTaxonomy :CRITERION.AWARD.OTHER;'"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- :AwardCriterion individual -->
    <xsl:template match="ted:AC_QUALITY | ted:AC_COST | ted:AC_PRICE">
        <xsl:variable name="item_id" select="parent::*/@ITEM"/> 
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':AwardCr_', count(following-sibling::*), '_', $item_id, '_', $identifier, ' rdf:type :AwardCriterion;')"/>
        </xsl:call-template>
        
        <!-- :AwardCriterion :hasAwardCriterionPropertyGroup :AwardCriterionPropertyGroup -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasAwardCriterionPropertyGroup :AwardCrPG_', count(following-sibling::*), '_', $item_id, '_', $identifier, ';')"/>
        </xsl:call-template>
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':appliesToLot :Lot_', $item_id, '_', $identifier, ' ;')"/>
        </xsl:call-template>
        
        <!--xsl:choose>
            <xsl:when test="not($lot_num castable as xs:integer) and contains($lot_num, ',')">
                <xsl:variable name="first_value" select="substring-before($lot_num,',')"/>
                
                <xsl:call-template name="add_property_string">
                    <xsl:with-param name="triple" select="concat(':AwardCr_', count(following-sibling::*), '_', $item_id, '_', $identifier, ' rdf:type :AwardCriterion;')"/>
                </xsl:call-template>
                
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasAwardCriterionPropertyGroup :AwardCrPG_', count(following-sibling::*), '_', $item_id, '_', $identifier, ';')"/>
                </xsl:call-template>
                
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':appliesToLot :Lot_', $item_id, '_', $identifier, ' ;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="add_property_string">
                    <xsl:with-param name="triple" select="concat(':AwardCr_', count(following-sibling::*), '_', $lot_num, '_', $identifier, ' rdf:type :AwardCriterion;')"/>
                </xsl:call-template>
                
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasAwardCriterionPropertyGroup :AwardCrPG_', count(following-sibling::*), '_', $lot_num, '_', $identifier, ';')"/>
                </xsl:call-template>
                
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':appliesToLot :Lot_', $lot_num, '_', $identifier, ' ;')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose-->
        
        <!-- :AwardCriterion :usesCriterionTaxonomy :CriterionTaxonomy -->
        <xsl:call-template name="AwardCriteriaType"/>
        
        <!-- :AwardCriterion :hasCriterionDescription xsd:String -->
        <xsl:choose>
            <xsl:when test="exists(ted:AC_CRITERION)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasCriterionDescription &quot;', replace(ted:AC_CRITERION, '&quot;', '”'), '&quot; ;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':hasCriterionDescription &quot;Price&quot; ;'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- :AwardCriterion :usesEvaluationMethodType :EvaluationMethodType -->
        <xsl:if test="(exists(ted:AC_WEIGHTING))">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="'epo-rd:usesEvaluationMethodType :WEIGHTED;'"/>
            </xsl:call-template>
        
            <!-- :AwardCriterion :hasCriterionWeight xsd:decimal -->
            <xsl:if test="(number(ted:AC_WEIGHTING))">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasCriterionWeight ', ted:AC_WEIGHTING, ';')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        
        <xsl:call-template name="end_triple"/>
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :AwardCriterionPropertyGroup individual -->
        <!--xsl:choose>
            <xsl:when test="not($lot_num castable as xs:integer) and contains($lot_num, ',')">
                <xsl:variable name="first_value" select="substring-before($lot_num,',')"/>
                
                <xsl:call-template name="awardCriterionPropertyGroup">
                    <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $first_value, '_', $identifier)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="awardCriterionPropertyGroup">
                    <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $lot_num, '_', $identifier)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose-->
        <xsl:call-template name="awardCriterionPropertyGroup">
            <xsl:with-param name="individual_id" select="concat(count(following-sibling::*), '_', $item_id, '_', $identifier)"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <!-- :AwardCriterionPropertyGroup individual -->
    <xsl:template name="awardCriterionPropertyGroup">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':AwardCrPG_', $individual_id, ' rdf:type :AwardCriterionPropertyGroup;')"/>
        </xsl:call-template>
        
        <!-- :AwardCriterionPropertyGroup :hasAwardCriterionProperty :AwardCriterionProperty -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasAwardCriterionProperty :AwardCrP_', $individual_id, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        
        <!-- :AwardCriterionProperty individual -->
        <xsl:call-template name="awardCriterionProperty">
            <xsl:with-param name="individual_id" select="$individual_id"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :AwardCriterionProperty individual -->
    <xsl:template name="awardCriterionProperty">
        <xsl:param name="individual_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':AwardCrP_', $individual_id, ' rdf:type :AwardCriterionProperty;')"/>
        </xsl:call-template>
        
        <!-- :AwardCriterionProperty :hasCriterionPropertyDescription xsd:String -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasCriterionPropertyDescription &quot;Please describe them.&quot;.'"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
</xsl:stylesheet>