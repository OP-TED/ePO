<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcurementValue.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :ProcurementValue from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :ProcurementValue (when :ProcurementProcedure) -->
    <xsl:template name="ProcurementProject_hasEstimatedProcValue">
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        
        <xsl:if test="exists($object_contract/ted:VAL_ESTIMATED_TOTAL)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':EstPVPP_', $identifier, ' rdf:type :ProcurementValue;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="$object_contract/ted:VAL_ESTIMATED_TOTAL"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->        
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementValue (when :Lot) -->
    <xsl:template name="ProcurementProject_LotEstimatedProcValue">
        
        <xsl:if test="exists(ted:VAL_OBJECT)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':EstPVL_', @ITEM, '_', $identifier, ' rdf:type :ProcurementValue;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="ted:VAL_OBJECT"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementValue (when :Contract) -->
    <xsl:template name="ProcurementProject_ContractProcValue">
        <xsl:if test="exists(ted:VAL_RANGE_TOTAL) or exists(ted:VAL_TOTAL)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
                
            <xsl:variable name="lot_num" select="parent::*/ted:LOT_NO"/> 
            
            <xsl:choose>
                <xsl:when test="not($lot_num castable as xs:integer) and contains($lot_num, ',')">
                    <xsl:variable name="first_value" select="substring-before($lot_num,',')"/>
                    
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':PValueContract_', $first_value, '_', $identifier, ' rdf:type :ProcurementValue;')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="add_property_string">
                        <xsl:with-param name="triple" select="concat(':PValueContract_', replace(string($lot_num), '[^a-zA-Z0-9]', ''), '_', $identifier, ' rdf:type :ProcurementValue;')"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="ted:VAL_TOTAL, ted:VAL_RANGE_TOTAL/ted:LOW, ted:VAL_RANGE_TOTAL/ted:HIGH"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementValue (when :Contract as Design Contest) -->
    <xsl:template name="Contract_DesignContestProcValue">
        <xsl:if test="exists(ted:VAL_PRIZE)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':PValueContract_', parent::*/ted:LOT_NO, '_', $identifier, ' rdf:type :ProcurementValue;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="ted:VAL_PRIZE"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
        </xsl:if>        
    </xsl:template>
    
    <!-- :ProcurementValue :hasTotalAmount xsd:Decimal and :hasTaxIncludedIndicador xsd:Boolean -->
    <xsl:template match="ted:VAL_ESTIMATED_TOTAL | ted:VAL_OBJECT | ted:VAL_TOTAL | ted:VAL_PRIZE">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasTotalAmount ', .,';')"/>
        </xsl:call-template>
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasTaxIncludedIndicator false;'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcurementValue :hasMinimumAmount ccts:Amount -->
    <xsl:template match="ted:VAL_RANGE_TOTAL/ted:LOW">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasMinimumAmount ', ., ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcurementValue :hasMaximumAmount ccts:Amount -->
    <xsl:template match="ted:VAL_RANGE_TOTAL/ted:HIGH">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasMaximumAmount ', ., ';')"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>