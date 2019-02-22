<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Simple_classes.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :Period from ePO
    ####################################################################################
    -->
    
    <!-- :Period individual -->
    <xsl:template name="period">
        <xsl:param name="individual_identifier"/>
        <xsl:param name="start_date"/>
        <xsl:param name="end_date"/>
        <xsl:param name="duration"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat($individual_identifier,' rdf:type :Period;')"/>
        </xsl:call-template>
        
        <!-- :Period :hasStartDate xsd:Date -->
        <xsl:if test="exists($start_date)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasStartDate &quot;', $start_date,'&quot;^^xsd:dateTime ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Period :hasEndDate xsd:Date -->
        <xsl:if test="exists($end_date)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEndDate &quot;', $end_date,'&quot;^^xsd:dateTime ;')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Period :hasDuration xsd:Date -->
        <xsl:if test="exists($duration)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasDuration ', $duration,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="end_triple"/>  
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
    </xsl:template>
    
</xsl:stylesheet>