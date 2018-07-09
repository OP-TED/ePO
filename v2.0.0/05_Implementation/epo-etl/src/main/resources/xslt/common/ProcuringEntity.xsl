<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcuringEntity.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : CONTRACTING_BODY from TED to :ProcuringEntity from ePO
    ####################################################################################
    -->
    <xsl:import href="ProcuringEntity_classes.xsl"/>
    
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014')]/name()"/>
    
    <!-- TED - CONTRACTING_BODY maps to ePO - ProcuringEntity -->
    <xsl:template match="ted:CONTRACTING_BODY[parent::*/@CATEGORY = 'ORIGINAL']">
        <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014')]/name()"/>
        
        <!-- :ProcuringEntity individual (TED XML has only one CONTRACTING_BODY. ePO :ProcuringProcedure has one and only one :ProcuringEntity) -->
        <xsl:call-template name="ProcuringEntityIndividual"/>
    </xsl:template>
    
    <!-- :ProcuringEntity individual -->
    <xsl:template name="ProcuringEntityIndividual">        
        <!-- Start SPARQL query :ProcuringEntity individual -->
        <xsl:call-template name="create_individual_begin_where">
            <xsl:with-param name="subject" select="concat(':PE', $identifier)"/>
            <xsl:with-param name="object" select="':ProcuringEntity'"/>
        </xsl:call-template>
        
        <!-- :ProcuringEntity :usesProcuringEntityType epo-rd:CA (Contracting Authority) or epo-rd:CE (Contracting Entity) -->
        <xsl:call-template name="ProcuringEntityType"/>
        
        
        <xsl:apply-templates select="ted:ADDRESS_CONTRACTING_BODY/ted:OFFICIALNAME, ted:ADDRESS_CONTRACTING_BODY/ted:NATIONALID"/>
        
        <xsl:if test="exists(ted:ADDRESS_CONTRACTING_BODY)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat('org:hasSite :PESite_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>
        	    
        <!-- :ProcuringEntity :usesMainActivityTaxonomy epo-rd:MainActivityTaxonomy -->
        <xsl:if test="exists(ted:CA_ACTIVITY) or exists(ted:CE_ACTIVITY)">
            <xsl:call-template name="ProcuringEntityActivityTaxonomy"/>
        </xsl:if>
        
        <!-- :ProcuringEntity :usesJurisdictionalCompetenceLevelType epo-rd:JurisdictionalCompetenceLevelType -->
        <xsl:apply-templates select="ted:CA_TYPE"/>
        
        <!-- :ProcuringEntity :hasBuyerProfile :BuyerProfile -->
        <xsl:apply-templates select="ted:ADDRESS_CONTRACTING_BODY/ted:URL_BUYER"/>
        
        <!-- :ProcuringEntity :usesJointProcurementEntityRoleType :JPL (Joint Procurement Lead) if JOINT_PROCUREMENT_INVOLVED element exist -->
        <xsl:choose>
            <xsl:when test="exists(ted:JOINT_PROCUREMENT_INVOLVED)">
                <xsl:call-template name="jointProcurement"/>
            </xsl:when>
            <xsl:otherwise><xsl:call-template name="end_triple"/></xsl:otherwise>
        </xsl:choose>        
        
        <!-- :BuyerProfile individual -->
        <xsl:if test="exists(ted:ADDRESS_CONTRACTING_BODY/ted:URL_BUYER)">
            <xsl:call-template name="BuyerProfile"/>
        </xsl:if>
        
        <xsl:call-template name="hasSite">
            <xsl:with-param name="current_values" select="ted:ADDRESS_CONTRACTING_BODY"/>
            <xsl:with-param name="site_id" select="$identifier"/>
        </xsl:call-template>
        
        <!-- Close SPARQL query and add filter -->
        <xsl:call-template name="filter">
            <xsl:with-param name="filter_triple" select="concat('?a  skos:prefLabel &quot;', replace(ted:ADDRESS_CONTRACTING_BODY/ted:OFFICIALNAME, '&quot;', '”'), '&quot; .')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcuringEntity :usesProcuringEntityType epo-rd:CA (Contracting Authority) or epo-rd:CE (Contracting Entity), depending on the FORM_SECTION/child::*/name() type -->
    <xsl:template name="ProcuringEntityType">
        <!-- Every form has pre-defined the ProcuringEntityType, except F08_2014, F12_2014, F13_2014, F15_2014 which could have both types -->
        
        <xsl:if test="ted:CA_TYPE, ted:CA_TYPE_OTHER, ted:CA_ACTIVITY, ted:CA_ACTIVITY_OTHER">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="':usesProcuringEntityType epo-rd:CA;'"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="ted:CE_TYPE, ted:CE_TYPE_OTHER, ted:CE_ACTIVITY, ted:CE_ACTIVITY_OTHER">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="':usesProcuringEntityType epo-rd:CE;'"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcuringEntity :usesJurisdictionalCompetenceLevelType epo-rd:JurisdictionalCompetenceLevelType -->
    <xsl:template match="ted:CA_TYPE">
        <!-- Mapping between CA_TYPE code list in TED and JurisdictionalCompetenceLevelType in ePO is done in MappingStructure.xml file -->
        <xsl:variable name="ca_type" select="@VALUE"/>
        <xsl:variable name="type" select="document('MappingStructure.xml')/FORM_SECTION/JurisdictionalCompetenceLevelCode/section[@tedValue=$ca_type]/@epoValue"/>
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':usesJurisdictionalCompetenceLevelType ',$type, ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcuringEntity :usesMainActivityTaxonomy epo-rd:MainActivityTaxonomy -->
    <xsl:template name="ProcuringEntityActivityTaxonomy">
        <xsl:variable name="activity" select="if(exists(ted:CA_ACTIVITY)) then ted:CA_ACTIVITY/@VALUE else ted:CE_ACTIVITY/@VALUE"/>
        
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':usesMainActivityTaxonomy epo-rd:', $activity, ';')"/>
        </xsl:call-template>
    </xsl:template>    
      
    <!-- :ProcuringEntity :usesJointProcurementEntityRoleType :JPL (Joint Procurement Lead) if JOINT_PROCUREMENT_INVOLVED element exist -->
    <xsl:template name="jointProcurement">
        <!-- Main :ProcuringEntity has the JPL role of the joint procurement -->
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':usesJointProcurementEntityRoleType epo-rd:JPL;'"/>
        </xsl:call-template>
        
        <!-- Main :ProcuringEntity :isJointProcurement, relates with the other members of the joint procurement (ADDRESS_CONTRACTING_BODY_ADDITIONAL) -->
        <xsl:for-each select="ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL">
            <xsl:variable name="id_number" select="count(following-sibling::ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL)"/>
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':isJointProcurement'"/>
                <xsl:with-param name="object" select="concat(':PE_',$id_number, '_', $identifier)"/>
                <xsl:with-param name="last" select="if($id_number=0) then true() else false()"/>
            </xsl:call-template>
        </xsl:for-each>
        
        <!-- Each joint procurement members must be inserted as :ProcuringEntity individual with :hasJointProcurementEntityRoleType :JPM role -->
        <xsl:call-template name='jointProcurementEntity'/>
    </xsl:template>
    
    <!-- Each joint procurement members must be inserted as :ProcuringEntity individual with :usesJointProcurementEntityRoleType :JPM role -->
    <xsl:template name="jointProcurementEntity">
        <xsl:variable name="root_name" select="/*[1]/ted:FORM_SECTION/child::*[contains(name(), '_2014')]/name()"/>
        
        <xsl:for-each select="ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL">
            <xsl:variable name="id_number" select="count(following-sibling::ted:ADDRESS_CONTRACTING_BODY_ADDITIONAL)"/>
            <!-- :ProcuringEntity individual -->
            <xsl:call-template name="add_property">
                <xsl:with-param name="subject" select="concat(':PE_',$id_number, '_', $identifier)"/>
                <xsl:with-param name="predicate" select="'rdf:type'"/>
                <xsl:with-param name="object" select="':ProcuringEntity'"/>
                <xsl:with-param name="last" select="false()"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="ted:OFFICIALNAME, ted:NATIONALID"/>
            
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat('org:hasSite :PESite_',$id_number, '_', $identifier, ';')"/>
            </xsl:call-template>
            
            <!-- :ProcuringEntity has the JPM role of the joint procurement -->
            <xsl:call-template name="add_property_no_subject">
                <xsl:with-param name="predicate" select="':usesJointProcurementEntityRoleType'"/>
                <xsl:with-param name="object" select="':JPM'"/>
                <xsl:with-param name="last" select="true()"/>
            </xsl:call-template>
            
            <xsl:call-template name="hasSite">
                <xsl:with-param name="current_values" select="."/>
                <xsl:with-param name="site_id" select="concat($id_number, '_', $identifier)"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- :ProcurementProcedure :hasProcuringEntity :ProcurintEntity -->
    <xsl:template name="hasProcuringEntity">
        <xsl:variable name="PE_name" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY/ted:ADDRESS_CONTRACTING_BODY"/>
        
        <xsl:call-template name="create_insert_where"/>
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':PProc', $identifier, ' :hasProcuringEntity ?a.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="select">
            <xsl:with-param name="select_triple" select="concat('?a  skos:prefLabel &quot;', replace($PE_name/ted:OFFICIALNAME, '&quot;', '”'),'&quot;.')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :contract :refersToSignatoryPartyProcuringEntity :ProcurintEntity -->
    <xsl:template name="refersToPE">
        <xsl:variable name="PE_name" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:CONTRACTING_BODY/ted:ADDRESS_CONTRACTING_BODY"/>
        <xsl:variable name="award_item" select="@ITEM"/>
        
        <xsl:call-template name="create_insert_where"/>
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Contract_', $award_item, '_', $identifier, ' :refersToSignatoryPartyProcuringEntity ', concat(':PE', $identifier), '.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="filter">
            <xsl:with-param name="filter_triple" select="concat('?a  skos:prefLabel &quot;',replace($PE_name/ted:OFFICIALNAME, '&quot;', '”'), '&quot;.')"/>
        </xsl:call-template>
        
        
        <xsl:call-template name="create_insert_where"/>
        <xsl:call-template name="add_property_string">
            <xsl:with-param name="triple" select="concat(':Contract_', $award_item, '_', $identifier, ' :refersToSignatoryPartyProcuringEntity ?a.')"/>
        </xsl:call-template>
        
        <xsl:call-template name="select">
            <xsl:with-param name="select_triple" select="concat('?a  skos:prefLabel &quot;', replace($PE_name/ted:OFFICIALNAME, '&quot;', '”'),'&quot;.')"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>