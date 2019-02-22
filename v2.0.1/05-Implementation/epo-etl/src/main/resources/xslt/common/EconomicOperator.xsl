<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : EconomicOperator.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : CONTRACTOR from TED to :Winner, a subclass of :EconomicOperator from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- TED - CONTRACTOR maps :Winner in ePO (when design contest) -->
    <xsl:template name="Winner_DesignContest">
        <xsl:param name="award_id"/>
        <xsl:param name="winner"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':WEO_', $award_id, '_', $identifier, ' rdf:type :Winner;')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_EO">
            <xsl:with-param name="context" select="$winner"/>
            <xsl:with-param name="context_address" select="$winner/ted:ADDRESS_WINNER"/>
            <xsl:with-param name="id" select="''"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->      
    </xsl:template>
    
    <!-- TED - CONTRACTOR maps :Winner in ePO -->
    <xsl:template name="Winner">
        <xsl:param name="award_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':WEO_', $award_id, '_', $identifier, ' rdf:type :Winner;')"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_EO">
            <xsl:with-param name="context" select="ted:CONTRACTOR"/>
            <xsl:with-param name="context_address" select="ted:CONTRACTOR/ted:ADDRESS_CONTRACTOR"/>
            <xsl:with-param name="id" select="''"/>
        </xsl:call-template>
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->      
    </xsl:template>
    
    <!-- :Winner individual -->
    <xsl:template name="create_EOGroup">
        <xsl:param name="award_id"/>
        
        <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
        
        <!-- Start SPARQL query :Winner individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="concat(':WEOG_0_', $award_id, '_', $identifier)"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="':Winner'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- :Winner :groupsAsAnEO :Winner -->
        <xsl:for-each select="ted:CONTRACTOR">
            <xsl:variable name="id_number" select="count(preceding-sibling::ted:CONTRACTOR)"/>
            <xsl:if test="number($id_number)&gt;0">
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':groupsAsAnEO'"/>
                    <xsl:with-param name="object" select="concat(':WEOG_',$id_number, '_', $award_id, '_', $identifier)"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:call-template name="create_EO">
            <xsl:with-param name="context" select="ted:CONTRACTOR[1]"/>
            <xsl:with-param name="context_address" select="ted:CONTRACTOR[1]/ted:ADDRESS_CONTRACTOR"/>
            <xsl:with-param name="id" select="''"/>
        </xsl:call-template>
        
        <!-- Each :Winner memebers must be inserted as :Winner individual with :isGroupOfEO _:EOG -->
        <xsl:call-template name="create_EOGroup_members">
            <xsl:with-param name="award_id" select="$award_id"/>
        </xsl:call-template>  
        
        <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->   
    </xsl:template>
    
    <!-- Each :Winner memebers must be inserted as :Winner individual with :isGroupOfEO _:EOG -->
    <xsl:template name="create_EOGroup_members">
        <xsl:param name="award_id"/>
        
        <xsl:for-each select="ted:CONTRACTOR">
            <xsl:variable name="id_number" select="count(preceding-sibling::ted:CONTRACTOR)"/>
            <xsl:if test="number($id_number)&gt;0">
                <!-- :Winner individual -->
                <xsl:call-template name="add_property">
                    <xsl:with-param name="subject" select="concat(':WEOG_',$id_number, '_', $award_id, '_', $identifier)"/>
                    <xsl:with-param name="predicate" select="'rdf:type'"/>
                    <xsl:with-param name="object" select="':Winner'"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
                <xsl:call-template name="add_property_no_subject">
                    <xsl:with-param name="predicate" select="':isGroupOfEO'"/>
                    <xsl:with-param name="object" select="concat(':WEOG_0_', $award_id, '_', $identifier)"/>
                    <xsl:with-param name="last" select="false()"/>
                </xsl:call-template>
                <xsl:call-template name="create_EO">
                    <xsl:with-param name="context" select="."/>
                    <xsl:with-param name="context_address" select="./ted:ADDRESS_CONTRACTOR"/>
                    <xsl:with-param name="id" select="$id_number"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :Winner individual -->
    <xsl:template name="create_EO">
        <xsl:param name="context"/>
        <xsl:param name="context_address"/>
        <xsl:param name="id"/>
        
        <xsl:if test="exists($context/parent::*[1]/parent::*[1]/@ITEM)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':hasWinnerRank'"/>
                <xsl:with-param name="object" select="number($context/parent::*[1]/parent::*[1]/@ITEM)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Winner usesEOIndustryClassificationType :SME (if CONTRACTOR/SME exist) or :LARGE (if CONTRACTOR/NO_SME exist) -->
        <xsl:if test="exists($context/ted:SME) or exists($context/ted:NO_SME)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':usesEOIndustryClassificationType'"/>
                <xsl:with-param name="object" select="if(exists($context/ted:SME))then 'epo-rd:SME' else 'epo-rd:NO_SME'"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Winner rov:legalName rdfs:Literal -->
        <xsl:if test="exists($context_address/ted:OFFICIALNAME)">
            <xsl:variable name="officialname" select="$context_address/ted:OFFICIALNAME"/>
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'rov:legalName'"/>
                <xsl:with-param name="object" select="concat('&quot;', replace($officialname, '&quot;', '”'), '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Winner rov:registration _:WID (adms:Identifier individual) -->
        <xsl:if test="exists($context_address/ted:NATIONALID)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'rov:registration'"/>
                <xsl:with-param name="object" select="concat('_:WID', $id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Winner org:hasRegisteredSite _:WADD (vcard:Individual individual) -->
        <xsl:if test="exists($context_address)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'org:hasRegisteredSite'"/>
                <xsl:with-param name="object" select="concat('_:WADD', $id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :Winner usesEORoleType :SC -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':usesEORoleType epo-rd:SOLE_CONTRACTOR.'"/>
        </xsl:call-template>
        
        <!-- adms:Identifier individual -->
        <xsl:if test="exists($context_address/ted:NATIONALID)">
            <xsl:call-template name="create_adms_identifier">
                <xsl:with-param name="subject" select="concat('_:WID', $id)"/>
                <xsl:with-param name="identifier" select="$context_address/ted:NATIONALID"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual individual  -->
        <xsl:if test="exists($context_address)">
            <xsl:call-template name="create_vcard">
                <xsl:with-param name="subject" select="concat('_:WADD', $id)"/>
                <xsl:with-param name="context" select="$context_address"/>
                <xsl:with-param name="id" select="$id"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- vcard:Individual individual  -->
    <xsl:template name="create_vcard">
        <xsl:param name="subject"/>
        <xsl:param name="context"/>
        <xsl:param name="id"/>
        
        <!-- vcard:Individual individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="'vcard:Individual'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:Individual vcard:hasEmail literal -->
        <xsl:if test="exists($context/ted:E_MAIL)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasEmail'"/>
                <xsl:with-param name="object" select="concat('&quot;', $context/ted:E_MAIL, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual vcard:hasURL anyURI -->
        <xsl:if test="exists($context/ted:URL)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasURL'"/>
                <xsl:with-param name="object" select="concat('&quot;', $context/ted:URL, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual vcard:hasTelephone vcard:Cell -->
        <xsl:if test="exists($context/ted:PHONE)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasTelephone'"/>
                <xsl:with-param name="object" select="concat('_:CELL', $id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual vcard:hasTelephone vcard:Fax -->
        <xsl:if test="exists($context/ted:FAX)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:hasTelephone'"/>
                <xsl:with-param name="object" select="concat('_:FAX', $id)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Individual vcard:hasAddress vcard:Address -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'vcard:hasAddress'"/>
            <xsl:with-param name="object" select="concat('_:ADR', $id)"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>
        
        
        <!-- vcard:Cell individual -->
        <xsl:if test="exists($context/ted:PHONE)">
            <xsl:call-template name="create_telph_type">
                <xsl:with-param name="subject" select="concat('_:CELL', $id)"/>
                <xsl:with-param name="object_type" select="'vcard:Cell'"/>
                <xsl:with-param name="object_value" select="$context/ted:PHONE"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Fax individual -->
        <xsl:if test="exists($context/ted:FAX)">
            <xsl:call-template name="create_telph_type">
                <xsl:with-param name="subject" select="concat('_:FAX', $id)"/>
                <xsl:with-param name="object_type" select="'vcard:Fax'"/>
                <xsl:with-param name="object_value" select="$context/ted:FAX"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Address individual -->
        <xsl:call-template name="create_address">
            <xsl:with-param name="subject" select="concat('_:ADR', $id)"/>
            <xsl:with-param name="context" select="$context"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- vcard:Address Individual -->
    <xsl:template name="create_address">
        <xsl:param name="subject"/>
        <xsl:param name="context"/>
        
        <!-- vcard:Address individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="'vcard:Address'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:Address vcard:street-address Literal -->
        <xsl:if test="exists($context/n2016:NUTS) or exists($context/NUTS)">
            <xsl:variable name="nuts_value" select="if(exists($context/n2016:NUTS)) then $context/n2016:NUTS/@CODE else $context/NUTS/@CODE"/>
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:region'"/>
                <xsl:with-param name="object" select="concat('epo-rd:', $nuts_value)"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Address vcard:street-address Literal -->
        <xsl:if test="exists($context/ted:ADDRESS)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:street-address'"/>
                <xsl:with-param name="object" select="concat('&quot;', $context/ted:ADDRESS, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Address vcard:postal-code Literal -->
        <xsl:if test="exists($context/ted:POSTAL_CODE)">
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="'vcard:postal-code'"/>
                <xsl:with-param name="object" select="concat('&quot;', $context/ted:POSTAL_CODE, '&quot;')"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- vcard:Address vcard:country-name Literal -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'vcard:country-name'"/>
            <xsl:with-param name="object" select="concat('euvoc:', $context/ted:COUNTRY/@VALUE)"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:Address vcard:locality Literal -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'vcard:locality'"/>
            <xsl:with-param name="object" select="concat('&quot;', $context/ted:TOWN, '&quot;')"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>
        
    </xsl:template>
    
    <!-- vcard:Cell or vcard:Fax vcard:hasValue Literal -->
    <xsl:template name="create_telph_type">
        <xsl:param name="subject"/>
        <xsl:param name="object_type"/>
        <xsl:param name="object_value"/>
        
        <!-- vcard:Cell or vcard:Fax individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="$object_type"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- vcard:hasValue Literal -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'vcard:hasValue'"/>
            <xsl:with-param name="object" select="concat('&quot;', $object_value, '&quot;')"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- adms:Identifier individual -->
    <xsl:template name="create_adms_identifier">
        <xsl:param name="subject"/>
        <xsl:param name="identifier"/>
        
        <!-- adms:Identifier individual -->
        <xsl:call-template name="add_property">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="predicate" select="'rdf:type'"/>
            <xsl:with-param name="object" select="'adms:Identifier'"/>
            <xsl:with-param name="last" select="false()"/>
        </xsl:call-template>
        
        <!-- adms:Identifier skos:notation literal -->
        <xsl:call-template name="add_property_no_subject">
            <xsl:with-param name="predicate" select="'skos:notation'"/>
            <xsl:with-param name="object" select="concat('&quot;', $identifier, '&quot;')"/>
            <xsl:with-param name="last" select="true()"/>
        </xsl:call-template>
    </xsl:template>
        
</xsl:stylesheet>