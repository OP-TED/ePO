# ePO Modules 

ePO is organised in modules. The main module is called ePO Core and contains the most essential concepts of the ontology.

In addition, there are the following modules that extend the Core:

- eAccess
- eCatalogue
- eContract
- eFulfilment
- eNotice
- eOrdering
- eSubmission
- eInvoicing
---

Each module folder is structured as follows:

- The *conventions_report* folder contains the [UML Conventions](https://meaningfy-ws.github.io/model2owl-docs/public-review/uml/conceptual-model-conventions.html) comformance report of the specified module (as an HTML page). An automatically generated report that lists the ontology concepts in the XML file (under the xmi_conceptual_model folder) that violate the ePO UML conventions.


- The *model2owl-config* folder contains the configuration files necessary for the [model2owl toolchain](https://github.com/OP-TED/model2owl) to transform the .xml file of the specified module to a formal OWL ontology including SHACL shapes.


- The *owl_ontology* folder contains the ontology files of the specified module, as well as the restriction files. The files are available in [XML/RDF](https://www.w3.org/TR/rdf-syntax-grammar/) and [Turtle/RDF](https://www.w3.org/TR/turtle/) formats.


- The *shacl_shapes* folder contains the [SHACL](https://www.w3.org/TR/shacl/) shapes of the specified module in RDF and Turtle format. SHACL ( Shapes Constraint Language) is a W3C standard used for validating the contents of an RDF graph. 


- The *[xmi](https://www.omg.org/spec/XMI/)_conceptual_model* folder contains the .xml file of the specified module. A representation of the UML model of the Ontology.


The modules mentioned above are defined in the [ePO Ontology Architecture file](https://github.com/OP-TED/ePO/blob/b7ee989c504333e8ebb6ab9f9ff56ceb0bfd918f/analysis_and_design/conceptual_model/ePO_CM.eap).

