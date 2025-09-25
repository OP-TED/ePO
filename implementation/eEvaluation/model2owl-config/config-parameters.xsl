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
    <xsl:variable name="includedPrefixesList" select="('epo', 'epo-not', 'epo-ord', 'epo-cat', 'epo-con', 'epo-ful','epo-eva','epo-awa','epo-qua','epo-req', 'epo-sub', 'epo-acc', 'epo-inv' )"/>
    <!-- This set of variables controls the generation of reused concepts within artifacts. -->
    <xsl:variable name="generateReusedConceptsSHACL" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsOWLcore" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsOWLrestrictions" select="fn:false()"/>
    <xsl:variable name="generateReusedConceptsGlossary" select="fn:false()"/>

<!--    This set of variables controls generation of comments and how they will generate in the output -->
    <xsl:variable name="commentsGeneration" select="fn:false()"/>
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
    <xsl:variable name="moduleReference" select="'eva'"/>
    <!--    rdfs:label -->
    <xsl:variable name="ontologyLabelCore" select="'eProcurement Ontology Evaluation - core'"/>
    <xsl:variable name="ontologyLabelRestrictions" select="'eProcurement Ontology Evaluation - core restrictions'"/>
    <xsl:variable name="ontologyLabelShapes" select="'eProcurement Ontology Evaluation - core shapes'"/>
    <!--    dct:title -->
    <xsl:variable name="ontologyTitleCore" select="'eProcurement Ontology Evaluation - core'"/>
    <xsl:variable name="ontologyTitleRestrictions" select="'eProcurement Ontology Evaluation - core restrictions'"/>
    <xsl:variable name="ontologyTitleShapes" select="'eProcurement Ontology Evaluation - core shapes'"/>
    <!--    dct:description-->
    <xsl:variable name="ontologyDescriptionCore"
        select="'The eProcurement Ontology Evaluation core describes the concepts and properties representing the European Public Procurement Evaluation domain. The provision of these semantics offers the basis for a common understanding of the domain for all stakeholders ensuring the quality of data exchange and transparency. The ontology restrictions are published in a separate artefact.'"/>
    <xsl:variable name="ontologyDescriptionRestrictions"
        select="'The eProcurement Ontology Evaluation core restrictions provides the restrictions and the inference-related specifications on the concepts and properties in the eProcurement Ontology Evaluation core.'"/>
    <xsl:variable name="ontologyDescriptionShapes"
        select="'The eProcurement Ontology Evaluation core shapes provides the generic datashape specifications for the eProcurement Ontology Evaluation core.'"/>
    <!--    rdfs:seeAlso -->
    <xsl:variable name="seeAlsoResources"
        select="
            ('https://github.com/OP-TED/ePO/releases',
            'https://joinup.ec.europa.eu/collection/eprocurement/solution/eprocurement-ontology/about',
            'https://op.europa.eu/en/web/eu-vocabularies/e-procurement',
            'https://docs.ted.europa.eu/home/index.html')"/>
    <!--    dct:issued-->
    <xsl:variable name="issuedDate" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <!--    dct:created-->
    <xsl:variable name="createdDate" select="'2021-06-01'"/>
    <!--    owl:incompatibleWith -->
    <xsl:variable name="incompatibleWith" select="'4.2.0'"/>
    <!--    owl:versionInfo -->
    <xsl:variable name="versionInfo" select="'5.0.0'"/>
    <!--    bibo:status-->
    <xsl:variable name="ontologyStatus" select="'Semantic Specification Release'"/>
    <!--    owl:priorVersion -->
    <xsl:variable name="priorVersion" select="'4.2.0'"/>
    <!--    vann:preferredNamespaceUri -->
    <xsl:variable name="preferredNamespaceUri" select="'http://data.europa.eu/a4g/ontology#'"/>
    <!--    vann:preferredNamespacePrefix -->
    <xsl:variable name="preferredNamespacePrefix" select="'epo'"/>

<!--    dct:license-->
    <xsl:variable name="licenseLiteral" select="'© European Union, 2014. Unless otherwise noted, the reuse of the Ontology is authorised under the European Union Public Licence v1.2 (https://eupl.eu/).'"/>

    <!--    dct:publisher-->
    <xsl:variable name="publisher" select="'http://publications.europa.eu/resource/authority/corporate-body/PUBL'"/>
    

    <!-- JSON metadata configuration -->
    <xsl:variable name="metadataJson" select="fn:json-doc('metadata.json')"/>

    <!-- suffix for URIs of sh:NodeShape instances in the SHACL artefact -->
    <xsl:variable name="nodeShapeURIsuffix" select="'Shape'"/>

    <xsl:variable name="generateReusedConceptsJSONLDcontext" select="fn:true()"/>
    <!-- If true, this option will annotate all SHACL concepts in the shapes
    artefact with the ontology IRI defined therein, using rdfs:isDefinedBy. -->
    <xsl:variable name="annotateShaclConceptsWithOntology" select="fn:true()"/>

    <xsl:variable name="moduleReference" select="'core'"/>
</xsl:stylesheet>
