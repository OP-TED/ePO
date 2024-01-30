Description: The eNotice module contains classes related to eNotices. It is structured in three 
packages: notice core, eForms standardisation and standard Forms standardisation. The standardisation
of the notices was done taking into account the notice types: planning, competition, Direct Award 
Prenotification, result, contract modification and completion. This is the so-called “phase 
organisation of the notices”.

Files:
The conventions_report file contains the UML Conventions Comformance Report of eNotice (as an HTML
page). An automatically generated report that states the UML conformance violations of the UML model 
in file eNotice.xml.

The model2owl-config file contains the configuration files necessary for the model2owl toolchain
(https://github.com/OP-TED/model2owl) to transform the eNotice.xml file to a formal OWL ontology
including SHACL shapes.

The owl_ontology file contains the eNotice ontology files, as well as the restriction files. The files
are available in both RDF (https://www.w3.org/RDF/) and Turtle (https://www.w3.org/TR/turtle/) formats. 

The shacl_shapes file contains the SHACL (https://www.w3.org/TR/shacl/) shapes of eNotice in RDF and
Turtle format. SHACL (Shapes Constraint Language) is a W3C standard used for validating the contents
of an RDF graph.   

The xmi_conceptual_model file contains the eNotice.xml file. A representation of the UML model of 
the Ontology.

