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
        select="fn:concat($base-shape-uri,$defaultDelimiter, $moduleReference, '-shape')"/>
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
    <xsl:variable name="enableGenerationOfConceptSchemes" select="fn:false()"/>

<!--    Property used for constraint level for enumerations-->
    <xsl:variable name="cvConstraintLevelProperty" select="'epo:constraintLevel'"/>


    <!--Allowed characters for a normalized string-->
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>
    <!--    Generate reused classes, attributes and connectors. Concepts with these prefixes will be included in the generated artefacts. -->
    <xsl:variable name="includedPrefixesList" select="('epo', 'epo-not', 'epo-ord', 'epo-cat', 'epo-con', 'epo-ful','epo-eva','epo-awa')"/>
    <!-- This set of variables controls the generation of reused concepts within artifacts. -->
    <xsl:variable name="generateReusedConceptsSHACL" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsOWLcore" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsOWLrestrictions" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsGlossary" select="fn:false()"/>

<!--    This set of variables controls generation of comments and how they will generate in the output -->
    <xsl:variable name="commentsGeneration" select="fn:true()"/>
    <xsl:variable name="commentProperty" select="'skos:editorialNote'"/>

     <!--    Tag names/keys that are excluded from output -->
    <xsl:variable name="excludedTagNamesList" select="($statusProperty, $cvConstraintLevelProperty)"/>

    <!-- Variables for status filtering:
     - The property used to indicate the status
     - A list of valid statuses
     - A list of statuses to be excluded from the output
     - The default status value interpretation for elements without a status set -->
    <xsl:variable name="statusProperty" select="'epo:status'"/>
    <xsl:variable name="validStatusesList" select="('proposed', 'approved', 'implemented')"/>
    <xsl:variable name="excludedElementStatusesList" select="('proposed', 'approved')"/>
    <xsl:variable name="unspecifiedStatusInterpretation" select="'implemented'"/>


    <!-- This variable control if Object and Realisation are generated -->
    <xsl:variable name="generateObjectsAndRealisations" select="fn:false()"/>
<!--    Set of variables for convention report-->
    <xsl:variable name="conventionReportCopyrightText" select="'Publications Office of the European Union, 2023'"/>
    <xsl:variable name="conventionReportAuthor" select="'Publications Office of the European Union'"/>
    <xsl:variable name="conventionReportAuthorLocation" select="'Luxembourg'"/>
    <xsl:variable name="conventionReportAuthorWebsite" select="'https://op.europa.eu'"/>
    <xsl:variable name="conventionReportUMLModelName" select="'eProcurement'"/>
    <!-- URIs list of UML versions supported by model2owl -->
    <xsl:variable name="supportedUmlVersions"
        select="('http://www.omg.org/spec/UML/20131001',
            'https://www.omg.org/spec/UML/20131001',
            'http://www.omg.org/spec/UML/20161101',
            'https://www.omg.org/spec/UML/20161101'
        )"/>

    <!-- If enabled then any occurence of rdf:PlainLiteral datatype will be
    replaced in a SHACL shape. A list of the two string datatypes will be used
    instead: (xsd:string, rdf:langString).
    -->
    <xsl:variable name="translatePlainLiteralToStringTypesInSHACL" select="fn:true()"/>

    <!-- _______________________________________________________________________   -->
    <!--                            METADATA SECTION                               -->
    <!-- _______________________________________________________________________   -->
    <!--    This section contains the variables used to build the ontology metadata-->
    <xsl:variable name="moduleReference" select="'core'"/>
    <!--    dct:title -->
    <xsl:variable name="ontologyTitleCore" select="'ePO Core core'"/>
    <xsl:variable name="ontologyTitleRestrictions" select="'ePO Core restrictions'"/>
    <xsl:variable name="ontologyTitleShapes" select="'ePO Core shapes'"/>
    <!--    dct:description-->
    <xsl:variable name="ontologyDescriptionCore"
        select="
        'This artefact provides the definitions for the eProcurement Ontology Core.
        This artefact excludes the restrictions.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>

        <xsl:variable name="ontologyDescriptionRestrictions"
        select="
        'This artefact provides the restrictions and inference-related specifications for the eProcurement Ontology Core.
        This artefact excludes the definitions of concepts.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>

    <xsl:variable name="ontologyDescriptionShapes"
        select="
        'This artefact provides the generic datashape specifications for the eProcurement Ontology Core.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>


    <!--    rdfs:label-->
    <xsl:variable name="ontologyLabelCore"
        select="
        'This artefact provides the definitions for the eProcurement Ontology Core.
        This artefact excludes the restrictions.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>

    <xsl:variable name="ontologyLabelRestrictions"
        select="
        'This artefact provides the restrictions and inference-related specifications for the eProcurement Ontology Core.
        This artefact excludes the definitions of concepts.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>

    <xsl:variable name="ontologyLabelShapes"
        select="
        'This artefact provides the generic datashape specifications for the eProcurement Ontology Core.
        The eProcurement Ontology describes objects and concepts, with definitions, attributes and relationships which are present within the European public procurement domain.
        The provision of these concepts provides the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency.'"/>

    <!--    rdfs:seeAlso -->
    <xsl:variable name="seeAlsoResources"
        select="
            ('https://github.com/eprocurementontology/eprocurementontology',
            'https://joinup.ec.europa.eu/collection/eprocurement/solution/eprocurement-ontology/about', 'https://op.europa.eu/en/web/eu-vocabularies/e-procurement',
            'https://docs.ted.europa.eu/EPO/latest/index.html')"/>
    <!--    dct:issued-->
    <xsl:variable name="issuedDate" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <!--    dct:created-->
    <xsl:variable name="createdDate" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <!--    owl:incompatibleWith -->
    <xsl:variable name="incompatibleWith" select="'2.1.0'"/>
    <!--    owl:versionInfo -->
    <xsl:variable name="versionInfo" select="'5.0.0'"/>
    <!--    bibo:status-->
    <xsl:variable name="ontologyStatus" select="'Semantic Specification Realease'"/>
    <!--    owl:priorVersion -->
    <xsl:variable name="priorVersion" select="'4.2.0'"/>
    <!--    vann:preferredNamespaceUri -->
    <xsl:variable name="preferredNamespaceUri" select="'http://data.europa.eu/a4g/ontology#'"/>
    <!--    vann:preferredNamespacePrefix -->
    <xsl:variable name="preferredNamespacePrefix" select="'epo'"/>

<!--    dct:license-->
    <xsl:variable name="licenseLiteral" select="'The Commission’s reuse policy is implemented by Commission Decision2011/833/EU of 12 December 2011 on the reuse of Commission documents 
        (OJ L 330,14.12.2011, p. 39 – https://eur-lex.europa.eu/eli/dec/2011/833/oj). Unlessotherwise noted, the reuse of this document is authorised under the 
        CreativeCommons Attribution 4.0 International (CC BY 4.0) licence (https://creativecommons.org/licenses/by/4.0/).This means that reuse is allowed, provided 
        that appropriate credit is given and any changes are indicated.'"/>

    <!--    dct:publisher-->
    <xsl:variable name="publisher" select="'http://publications.europa.eu/resource/authority/corporate-body/PUBL'"/>
    

</xsl:stylesheet>
