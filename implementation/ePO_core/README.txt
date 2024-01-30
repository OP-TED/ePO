Description: ePO core is the main module of ePO ontology containing the fundamental parts of ePO.   

Files:
The conventions_report file contains the UML Conventions Comformance Report of ePO core (as an HTML
 page). An automatically generated report that states the UML conformance violations of the UML model
in file ePO_core.xml.

The model2owl-config file contains the configuration files necessary for the model2owl toolchain
(https://github.com/OP-TED/model2owl) to transform the ePO_core.xml file to a formal OWL ontology
including SHACL shapes.

The owl_ontology file contains the core ontology files, as well as the restriction files. The files
are available in both RDF (https://www.w3.org/RDF/) and Turtle (https://www.w3.org/TR/turtle/)
formats. 

The shacl_shapes file contains the SHACL (https://www.w3.org/TR/shacl/) shapes of ePO_core in RDF and
Turtle format. SHACL (Shapes Constraint Language) is a W3C standard used for validating the contents
of an RDF graph.   

The xmi_conceptual_model file contains the ePO_core.xml file. A representation of the UML model of 
the Ontology.

