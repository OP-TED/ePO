<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd xsl dc fn"
    xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vann="http://purl.org/vocab/vann/"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines project level variables and parameters</xd:p>
        </xd:desc>
    </xd:doc>



    <!-- a set of prefix-baseURI definitions -->
    <xsl:variable name="namespacePrefixes" select="fn:doc('namespaces.xml')"/>

    <!-- a mapping between UML atomic types to XSD datatypes  -->
    <xsl:variable name="umlDataTypesMapping" select="fn:doc('umlToXsdDataTypes.xml')"/>

    <!-- XSD datatypes that conform to OWL2 requirements   -->
    <xsl:variable name="xsdAndRdfDataTypes" select="fn:doc('xsdAndRdfDataTypes.xml')"/>
    <!--    set default namespace interpretation for lexical Qnames that are not prefix:localSegment or :localSegment. If this 
    is set to true localSegment will transform to :localSegment-->
    <xsl:variable name="defaultNamespaceInterpretation" select="fn:true()"/>

    <!-- Ontology base URI, configure as necessary. Do not use a trailing local delimiter 
        like in the namespace definition-->
    <!--<xsl:variable name="base-uri" select="'http://publications.europa.eu/ontology/ePO'"/>-->
    <xsl:variable name="base-ontology-uri" select="'http://data.europa.eu/a4g/ontology'"/>
    <xsl:variable name="base-shape-uri" select="'http://data.europa.eu/a4g/data-shape'"/>
    <xsl:variable name="base-restriction-uri" select="$base-ontology-uri"/>
    <!--    Shapes Module URI-->
    <xsl:variable name="shapeArtefactURI"
        select="fn:concat($base-shape-uri, $defaultDelimiter, $moduleReference, '-shape')"/>
    <!--    Restrictions Module URI-->
    <xsl:variable name="restrictionsArtefactURI"
        select="fn:concat($base-restriction-uri, $defaultDelimiter, $moduleReference, '-restriction')"/>
    <!--    Core Module URI-->
    <xsl:variable name="coreArtefactURI"
        select="fn:concat($base-ontology-uri, $defaultDelimiter, $moduleReference)"/>

    <!-- when a delimiter is missing in the base URI of a namespace, use this default value-->
    <xsl:variable name="defaultDelimiter" select="'#'"/>

    <!-- types of elements and names for attribute types that are acceptable to produce object properties -->
    <xsl:variable name="acceptableTypesForObjectProperties"
        select="('epo:Identifier', 'rdfs:Literal')"/>
    <!--    the type of attributes which takes values from a controlled list-->
    <xsl:variable name="controlledListType" select="'epo:Code'"/>
    <!-- Acceptable stereotypes -->
    <xsl:variable name="stereotypeValidOnAttributes" select="()"/>
    <xsl:variable name="stereotypeValidOnObjects" select="()"/>
    <xsl:variable name="stereotypeValidOnGeneralisations"
        select="('Disjoint', 'Equivalent', 'Complete')"/>
    <xsl:variable name="stereotypeValidOnAssociations" select="()"/>
    <xsl:variable name="stereotypeValidOnDependencies" select="('Disjoint', 'disjoint', 'join')"/>
    <xsl:variable name="stereotypeValidOnClasses" select="('Abstract')"/>
    <xsl:variable name="stereotypeValidOnDatatypes" select="()"/>
    <xsl:variable name="stereotypeValidOnEnumerations" select="()"/>
    <xsl:variable name="stereotypeValidOnPackages" select="()"/>

    <xsl:variable name="abstractClassesStereotypes" select="('Abstract', 'abstract class', 'abstract')"/>

    <!--    This variable controls whether the enumeration items are transformed into skos concepts or ignored-->
    <xsl:variable name="enableGenerationOfSkosConcept" select="fn:false()"/>

    <!--    This variable controls whether the enumerations are transformed into skos schemes or ignored-->
    <xsl:variable name="enableGenerationOfConceptSchemes" select="fn:true()"/>

    <!--Allowed characters for a normalized string-->
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>



    <xsl:variable name="reference-to-external-classes-in-glossary" select="fn:true()"/>
    <!-- _______________________________________________________________________   -->
    <!--                            METADATA SECTION                               -->
    <!-- _______________________________________________________________________   -->
    <!--    This section contains the variables used to build the ontology metadata-->
    <xsl:variable name="moduleReference" select="'core'"/>
    <!--    dct:title -->
    <xsl:variable name="ontologyTitle" select="'eProcurement Ontology - core'"/>
    <!--    dct:description-->
    <xsl:variable name="ontologyDescription"
        select="
            'This module provides the definitions for the eProcurement ontology core.
        Procurement data has been identified as data with a high-reuse potential.
        Given the increasing importance of data standards for eProcurement, a number of initiatives
        driven by the public sector, the industry and academia have been kick-started in recent years.
        Some have grown organically, while others are the result of standardisation work.
        The vocabularies and the semantics that they are introducing, the phases of public procurement that they are covering,
        and the technologies that they are using all differ. These differences hamper data interoperability and thus its reuse by them or by the wider public.
        This creates the need for a common data standard for publishing procurement data, hence allowing data
        from different sources to be easily accessed and linked, and consequently reused.'"/>
    <!--    dct:abstract-->
    <xsl:variable name="abstractCore"
        select="'This artefact provides the ontology core specification.'"/>
    <xsl:variable name="abstractResctrictions"
        select="'This artefact provides the ontology extention with restrictions and inference-relaated specification.'"/>
    <xsl:variable name="abstractShapes"
        select="'This artefact provides the datashape specification. '"/>
    <!--    rdfs:seeAlso -->
    <xsl:variable name="seeAlsoResources"
        select="
            ('https://github.com/eprocurementontology/eprocurementontology',
            'https://joinup.ec.europa.eu/collection/eprocurement/solution/eprocurement-ontology/about', 'https://op.europa.eu/en/web/eu-vocabularies/e-procurement',
            'https://docs.ted.europa.eu/EPO/latest/index.html')"/>
    <!--    dct:created-->
    <xsl:variable name="createdDate" select="''"/>
    <!--    dct:issued-->
    <xsl:variable name="issuedDate" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <!--    owl:incompatibleWith -->
    <xsl:variable name="incompatibleWith" select="'3.1.0'"/>
    <!--    owl:versionInfo -->
    <xsl:variable name="versionInfo" select="'4.0.0'"/>
    <!--    bibo:status-->
    <xsl:variable name="ontologyStatus" select="'Semantic Specification Realease'"/>
    <!--    owl:priorVersion -->
    <xsl:variable name="priorVersion" select="'3.1.0'"/>
    <!--    vann:preferredNamespaceUri -->
    <xsl:variable name="preferredNamespaceUri" select="'http://data.europa.eu/a4g/ontology#'"/>
    <!--    vann:preferredNamespacePrefix -->
    <xsl:variable name="preferredNamespacePrefix" select="'epo'"/>

        <xsl:variable name="rightsLiteral" select="'The Commission’s reuse policy is implemented by Commission Decision2011/833/EU of 12 December 2011 on the reuse of Commission documents
        (OJ L 330,14.12.2011, p. 39 – https://eur-lex.europa.eu/eli/dec/2011/833/oj). Unlessotherwise noted, the reuse of this document is authorised under the
        CreativeCommons Attribution 4.0 International (CC BY 4.0) licence (https://creativecommons.org/licenses/by/4.0/).This means that reuse is allowed, provided
        that appropriate credit is given and any changes are indicated.'"/>
    <xsl:variable name="licenseURI" select="'http://creativecommons.org/licenses/by-sa/4.0'"/>
    <xsl:variable name="attributionNameLiteral" select="'European Union'"/>
    <xsl:variable name="attributionURL" select="'http://publications.europa.eu/resource/authority/corporate-body/EURUN'"/>

</xsl:stylesheet>