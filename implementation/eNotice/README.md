# eNotice 

**Description**:

The eNotice module contains classes related to eNotices. It is structured in three packages: notice core, eForms standardisation and standard Forms standardisation. The standardisation of the notices was done taking into account the notice types: planning, competition, direct award prenotification, result, contract modification and completion. This is the so-called “phase organisation of the notices”.

**Files**:
- The *conventions_report* folder contains the [UML Conventions](https://meaningfy-ws.github.io/model2owl-docs/public-review/uml/conceptual-model-conventions.html) comformance report of the eNotice module (as an HTML page). An automatically generated report that lists the ontology concepts in the eNotice.xml file that violate the ePO UML conventions.


- The *model2owl-config* folder contains the configuration files necessary for the [model2owl toolchain](https://github.com/OP-TED/model2owl) to transform the eNotice.xml file to a formal OWL ontology including SHACL shapes.


- The *owl_ontology* folder contains the eNotice ontology files, as well as the restriction files. The files are available in [XML/RDF](https://www.w3.org/TR/rdf-syntax-grammar/) and [Turtle/RDF](https://www.w3.org/TR/turtle/) formats.


- The *shacl_shapes* folder contains the [SHACL](https://www.w3.org/TR/shacl/) shapes of eNotice in RDF and Turtle format. SHACL ( Shapes Constraint Language) is a W3C standard used for validating the contents of an RDF graph. 


- The *[xmi](https://www.omg.org/spec/XMI/)_conceptual_model* folder contains the eNotice.xml file. A representation of the UML model of the Ontology.