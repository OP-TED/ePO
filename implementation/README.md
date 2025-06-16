# ePO Modules 

ePO is organised in modules. The main module is called ePO Core and contains the most essential concepts of the ontology.

In addition, there are the following modules that extend the Core:

- eCatalogue
- eContract
- eFulfilment
- eNotice
- eOrdering
- eAccess
- eSubmission
- eInvoicing
- eEvaluation
- eAwarding
- eQualification
- eRequest
- ePayment
---

Each module folder is structured as follows:

- The *owl_ontology* folder contains the ontology files of the specified module, as well as the restriction files. The files are available in [XML/RDF](https://www.w3.org/TR/rdf-syntax-grammar/) and [Turtle/RDF](https://www.w3.org/TR/turtle/) formats.


- The *shacl_shapes* folder contains the [SHACL](https://www.w3.org/TR/shacl/) shapes of the specified module in RDF and Turtle format. SHACL ( Shapes Constraint Language) is a W3C standard used for validating the contents of an RDF graph. 


The modules mentioned above are defined in the [ePO Conceptual Model file]()