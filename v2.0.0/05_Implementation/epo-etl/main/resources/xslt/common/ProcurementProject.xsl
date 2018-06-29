<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ted="ted/R2.0.9.S02/publication"
    xmlns:n2016="ted/2016/nuts"
    exclude-result-prefixes="xs"
    version="3.0">
    <!-- 
    ####################################################################################
    #  XSLT name : ProcurementProject.xsl
    #  RELEASE : "1.00"
    #  Last update : 06/2018
    #  Description : :ProcurementProject from ePO
    ####################################################################################
    -->
    <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
    
    <!-- :ProcurementProject data properties (when :ProcurementProcedure) -->
    <xsl:template name="ProcurementProject_DataProperties">   
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
                
        <!-- :ProcurementProject :hasPurpose :Purpose -->
        <xsl:if test="exists($object_contract/ted:CPV_MAIN) or exists($object_contract/ted:TYPE_CONTRACT)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasPurpose :PurpPP_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- :ProcurementProject :hasEstimatedProcurementValue :ProcurementValue -->
        <xsl:if test="exists($object_contract/ted:VAL_ESTIMATED_TOTAL)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasEstimatedProcurementValue :EstPVPP_', $identifier,';')"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates select=" $object_contract/ted:TITLE, $object_contract/ted:SHORT_DESCR"/>
        
        <xsl:if test="exists($object_contract/ted:REFERENCE_NUMBER)">
            <xsl:call-template name="add_property_no_subject_string">
                <xsl:with-param name="triple" select="concat(':hasProcurementProjectIdentifier :PProc_ID_', $identifier, ';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- :ProcurementProject :hasProcurementProjectTitle xsd:string -->
    <xsl:template match="ted:TITLE">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasProcurementProjectTitle &quot;', replace(., '&quot;', '”'), '&quot;', ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcurementProject :hasProcurementProjectDescription xsd:string -->
    <xsl:template match="ted:SHORT_DESCR">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasProcurementProjectDescription &quot;', replace(., '&quot;', '”'), '&quot;', ';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :ProcurementProject :hasProcurementProjectIdentifier ccts:Identifier -->
    <!--xsl:template match="ted:LOT_NO | ted:REFERENCE_NUMBER">
    </xsl:template-->
    
    <!-- :ProcurementProject object properties (when :ProcurementProcedure) -->
    <xsl:template name="ProcurementProject_ObjectProperties">
        <xsl:call-template name="ProcurementProject_hasPurpose"/>
        <xsl:call-template name="ProcurementProject_hasEstimatedProcValue"/>
    </xsl:template>
    
    <!-- :Purpose (when :ProcurementProcedure) -->
    <xsl:template name="ProcurementProject_hasPurpose">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        <xsl:variable name="object_contract" select="//ted:FORM_SECTION/child::*[@CATEGORY = 'ORIGINAL'][1]//ted:OBJECT_CONTRACT"/>
        
        <xsl:if test="exists($object_contract/ted:CPV_MAIN) or exists($object_contract/ted:TYPE_CONTRACT)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':PurpPP_', $identifier, ' rdf:type :Purpose;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="$object_contract/ted:TYPE_CONTRACT, $object_contract/ted:CPV_MAIN/ted:CPV_CODE, $object_contract/ted:CPV_MAIN/ted:CPV_SUPPLEMENTARY_CODE"/>
            
            <xsl:if test="not(exists($object_contract/ted:TYPE_CONTRACT))">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="':hasContractNatureCodeType :OTHER;'"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->            
        </xsl:if>
    </xsl:template>
    
    <!-- :Purpose (when :Lot) -->
    <xsl:template name="ProcurementProject_LotHasPurpose">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        
        <xsl:if test="exists(ted:OPTIONS) or exists(ted:NO_OPTIONS) or exists(ted:OPTIONS_DESCR) or exists(ted:NUTS) or exists(n2016:NUTS) or exists(ted:DATE_START) or exists(ted:DATE_END) or exists(ted:DURATION) or exists(ted:CPV_ADDITIONAL)">
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':PurpL_', @ITEM, '_', $identifier,' rdf:type :Purpose;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="ted:OPTIONS, ted:NO_OPTIONS, ted:OPTIONS_DESCR, ted:NUTS, n2016:NUTS, ted:CPV_ADDITIONAL/ted:CPV_CODE, ted:CPV_ADDITIONAL/ted:CPV_SUPPLEMENTARY_CODE"/>
            
            <!-- :Purpose (when :Lot) :hasContractEstimatedDuration :Period -->
            <xsl:if test="exists(ted:DATE_START) or exists(ted:DATE_END) or exists(ted:DURATION)">
                <xsl:call-template name="add_property_no_subject_string">
                    <xsl:with-param name="triple" select="concat(':hasContractEstimatedDuration :Period_', @ITEM, '_', $identifier,';')"/>
                </xsl:call-template>
            </xsl:if>
            
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->
            
            <xsl:if test="exists(ted:DATE_START) or exists(ted:DATE_END) or exists(ted:DURATION)">
                <xsl:call-template name="period">
                    <xsl:with-param name="individual_identifier" select="concat(':Period_', @ITEM, '_', $identifier)"/>
                    <xsl:with-param name="start_date" select="ted:DATE_START"/>
                    <xsl:with-param name="end_date" select="ted:DATE_END"/>
                    <xsl:with-param name="duration" select="ted:DURATION"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- :Purpose (when :Lot) :hasPurposeOptions xsd:Boolean -->
    <xsl:template match="ted:OPTIONS">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasPurposeOptions true;'"/>
        </xsl:call-template>        
    </xsl:template>
    
    <!-- :Purpose (when :Lot) :hasPurposeOptions xsd:Boolean -->
    <xsl:template match="ted:NO_OPTIONS">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasPurposeOptions false;'"/>
        </xsl:call-template>        
    </xsl:template>
    
    <!-- :Purpose (when :Lot) :hasPurposeOptionsDescription xsd:String -->
    <xsl:template match="ted:OPTIONS_DESCR">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasPurposeOptionsDescription &quot;', replace(., '&quot;', '”'),'&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :Purpose (when :Lot) :hasPlacePerformance :CountryCode -->
    <xsl:template match="ted:NUTS | n2016:NUTS">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasPlacePerformance euvoc:', @CODE,';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :Purpose (when ProcurementProcedure) :usesContractNatureType :ContractNatureCodeType -->
    <xsl:template match="ted:TYPE_CONTRACT">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':usesContractNatureType epo-rd:', @CTYPE,';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :Purpose :hasCPVType :CPVType -->
    <xsl:template match="ted:CPV_CODE | ted:CPV_SUPPLEMENTARY_CODE">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasCPVType epo-rd:', @CODE,';')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :FundsIdentification (when :Lot) -->
    <xsl:template name="ProcurementProject_LotFunds">
        <xsl:variable name="identifier" select="/*[1]/@DOC_ID"/>
        
        <!-- :Lot :hasFundsIdentification :FundsIdentification -->
        <xsl:if test="exists(ted:EU_PROGR_RELATED) or exists(ted:NO_EU_PROGR_RELATED)">            
            <xsl:call-template name="create_insert"/><!-- Start INSERT query -->
            
            <xsl:call-template name="add_property_string">
                <xsl:with-param name="triple" select="concat(':FundsL_', @ITEM, '_', $identifier,' rdf:type :FundsIdentification;')"/>
            </xsl:call-template>
            
            <xsl:apply-templates select="ted:EU_PROGR_RELATED, ted:NO_EU_PROGR_RELATED"/>
            
            <xsl:call-template name="end_triple"/>
            <xsl:call-template name="create_individual_end"/><!-- End INSERT query -->   
        </xsl:if>
    </xsl:template>
    
    <!-- :FundsIdentification :hasEUFunds xsd:boolean and :hasName xsd:String -->
    <xsl:template match="ted:EU_PROGR_RELATED">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasEUFunds true;'"/>
        </xsl:call-template>
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="concat(':hasName &quot;', replace(., '&quot;', '”'), '&quot; ;')"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- :FundsIdentification :hasEUFunds xsd:boolean -->
    <xsl:template match="ted:NO_EU_PROGR_RELATED">
        <xsl:call-template name="add_property_no_subject_string">
            <xsl:with-param name="triple" select="':hasEUFunds false;'"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>