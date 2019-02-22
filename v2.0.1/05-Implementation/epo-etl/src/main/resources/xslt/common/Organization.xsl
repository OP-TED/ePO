<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : Organization.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : org:Organization from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <xsl:template name="createOrganization">
        <xsl:param name="value"/>
        <xsl:param name="individual"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':', $individual, ' rdf:type org:Organization ;')"/>
        </xsl:call-template>
        
        <xsl:apply-templates select="$value/ted:OFFICIALNAME"/>
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('org:hasSite :PESite_', $individual, '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="hasSite">
            <xsl:with-param name="current_values" select="$value"/>
            <xsl:with-param name="site_id" select="$individual"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->    
        
    </xsl:template>
    
    
    <xsl:template name="hasSite">
        <xsl:param name="current_values"/>
        <xsl:param name="site_id"/>
        
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="concat(':PESite_', $site_id)"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="'vcard:Individual'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:Individual vcard:hasAddress vcard:Address -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'vcard:hasAddress'"/>
            <xsl:with-param name="object" select="concat(':PEAddress', $site_id)"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>
        
        
        <!-- vcard:Address individual -->
        <xsl:call-template name="address">
            <xsl:with-param name="subject" select="concat(':PEAddress', $site_id)"/>
            <xsl:with-param name="context" select="$current_values"/>
            <xsl:with-param name="individual_id" select="$site_id"/>
        </xsl:call-template>      
        
        <!-- vcard:Cell individual -->
        <xsl:if test="exists($current_values/ted:PHONE)">
            <xsl:call-template name="create_telph_type">
                <xsl:with-param name="subject" select="concat(':PECell_', $site_id)"/>
                <xsl:with-param name="object_type" select="'vcard:Cell'"/>
                <xsl:with-param name="object_value" select="$current_values/ted:PHONE"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Fax individual -->
        <xsl:if test="exists($current_values/ted:FAX)">
            <xsl:call-template name="create_telph_type">
                <xsl:with-param name="subject" select="concat(':PEFax_', $site_id)"/>
                <xsl:with-param name="object_type" select="'vcard:Fax'"/>
                <xsl:with-param name="object_value" select="$current_values/ted:FAX"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- vcard:Address Individual -->
    <xsl:template name="address">
        <xsl:param name="subject"/>
        <xsl:param name="context"/>
        <xsl:param name="individual_id"/>
        
        <!-- vcard:Address individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="'vcard:Address'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:Address vcard:street-address Literal -->
        <xsl:if test="exists($context/n2016:NUTS)">
            <xsl:call-template name="region">
                <xsl:with-param name="nuts_code" select="$context/n2016:NUTS/@CODE"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="exists($context/ted:NUTS)">
            <xsl:call-template name="region">
                <xsl:with-param name="nuts_code" select="$context/ted:NUTS/@CODE"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Address vcard:street-address Literal -->
        <xsl:apply-templates select="$context/ted:ADDRESS"/>
        
        <!-- vcard:Address vcard:postal-code Literal -->
        <xsl:apply-templates select="$context/ted:POSTAL_CODE"/>
        
        <!-- vcard:Address vcard:country-name Literal -->
        <xsl:apply-templates select="$context/ted:COUNTRY"/>
        
        <!-- vcard:Individual vcard:hasEmail literal -->
        <xsl:apply-templates select="$context/ted:E_MAIL"/>
        
        <!-- vcard:Address vcard:locality Literal -->
        <xsl:apply-templates select="$context/ted:TOWN"/>
        
        <!-- vcard:Individual vcard:hasTelephone vcard:Cell -->
        <xsl:if test="exists($context/ted:PHONE)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasTelephone'"/>
                <xsl:with-param name="object" select="concat(':PECell_', $individual_id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual vcard:hasTelephone vcard:Fax -->
        <xsl:if test="exists($context/ted:FAX)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasTelephone'"/>
                <xsl:with-param name="object" select="concat(':PEFax_', $individual_id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:call-template name="end_triple"/>
    </xsl:template>
    
    <!-- org:Organization skos:prefLabel xsd:String -->
    <xsl:template match="ted:OFFICIALNAME">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('skos:prefLabel &quot;', replace(., '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- org:Organization org:identifier xsd:String -->
    <xsl:template match="ted:NATIONALID">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('org:identifier &quot;', xs:normalizedString(.), '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- org:Organization vcard:region xsd:String -->
    <xsl:template name="region">
        <xsl:param name="nuts_code"/>
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:region epo-rd:', $nuts_code, ' ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:address vcard:street-address xsd:String -->
    <xsl:template match="ted:ADDRESS">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:street-address &quot;', replace(., '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:address vcard:postal-code xsd:String -->
    <xsl:template match="ted:POSTAL_CODE">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:postal-code &quot;', ., '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:address vcard:country-name CountryType -->
    <xsl:template match="ted:COUNTRY">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:country-name euvoc:', @VALUE, ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:address vcard:locality xsd:String -->
    <xsl:template match="ted:TOWN">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:locality &quot;', replace(., '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:address vcard:hasEmail xsd:String -->
    <xsl:template match="ted:E_MAIL">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat('vcard:hasEmail &quot;', ., '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>