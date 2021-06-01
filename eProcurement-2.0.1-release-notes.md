# eProcurement Ontology (ePO) version 2.0.1 - Release Notes 

Changes introduced in the evolution of the ePO since version 2.0.0 (end 2018):

## I. Conceptual model

The conceptual model, represented as UML diagrams, has evolved largely in respect of the previous version (v.2.0.0). 
The new conceptual model results mainly from comparing the previous model to the requirements introduced by the _eForms Regulation_ 
(Commission Implementing Regulation (EU) 2019/1780). Hence, the scope of the work has not varied between versions: eNotification and eAccess. 

As described in the Ontology Architecture documentation the caridinalites have been kept as permissive as possible in order to align with ISA2 practise on Core Vocabularies.

### Alignment ot eForms

Direct consequences of the Alignment to eForms have been:

1. The readjustment of the ePO Glossary. Concepts and terms have been reapproached, redefined and renamed; 

2. The introduction of additional UML diagrams that map how the needs and requirements about eNotification and eAccess, as expressed in eForms, 
are designed in ePO. This work can be seen in three main diagrams: _Planning_, _Competition_, and _Result_. Other diagrams, also mapping requirements taken from eForms are _Contract Modification_ and _Direct Award Prenotification_.

3. During the analysis of the mapping to eForms, new needs of reanalysis arised. That was the case when considering the concept of Role and 
the disambiguation betweeen Role and Agent. For these differences, see the diagrams: _Agent_, _Roles and Subroles_, _Buyer and Organisation_, and
_Economic Operator_.

4. Everything around _Lots_ has also been largely evolved. One important aspect in this new version is the introduction of the concept _TenderLot_, to differentiate the Lots defined by the Buyer from the parts of the Tender applied to the related Lot. This differentiation, as well as the definitions,can be seen in the diagrams _Lots_, _Evaluation Result_ and _Result_.

5. The detailed study on Lots has also revealed that the most important relations between classes are held with the Lots, instead of with the Procedure. 
It also led to the analysis of the _techniques and instruments_ used in procurement. Consequently, many of the terms and conditions defined in the 
phase of eNotification are related to the Lot. This can be clearly seen in the diagrams _Procurement Term_, _Framework Agreement Term_ and 
_Techniques and Instruments_.

6. As in the previous version, the analysis of the eNotification and eAccess phases has led to identify other information requirements from other phases. 
In these cases a first draft and design proposal, and even definitions, have been proposed in other UML diagrams, for example
the diagrams _Evaluation Result_, _eAward_ and _Submission_. 

### Consistency checking with OWL reasoners

After using the Hermit and Fact++ reasoners on the eProcurement ontology, four incostistencies emerged. Logical investigation and fixing is scheduled for the next version of the ontology. 
The 3 classes in question are: _ContractModificationNotice, DynamicPurchaseSystemTechnique and EAuctionTechnique_. 
The 4 properties in question are: _hasEAuctionUsage, hasModificationReason, hasParticipationEvaluationPeriod and modifies_.

## II. Design and OWL implementation

Version 2.0.1 of the ePO introduces two major decisions regarding the design and the implementation of the conceptual model into OWL artefacts:

### Naming conventions

Exclusive use of the ePO namespace, introduction of new naming and design rules, and future alignment to external ontologies and vocabularies. 
Only classes and properties than the are defined in the ePO namespace, are currently used.
In future releases, a _layer_ of alignment constraints is foreseen to map the entities defined in ePO to the ones defined in other vocabularies. 
The rationale for this is: 

* i) to ensure independence from external resources that are still under development (or not stable) or for 
which a study on how to reuse them is still pending; 
* ii) to accelerate the use of the ePO in the context of pilots or by any interested stakeholder; and 
* iii) to facilitate the development of automated mechanisms for the generation and maintenance of the implementation.

### Automated production of the OWL artefacts. 

In the previous version (ePO v2.0.0), an OWL-2 T-Box was implemented manually using Protégé and VocBench-3. 
In version ePO v2.0.1 an automatic transformation has been used to transform the UML diagrams into three artefacts: 

* i) An OWL (Turtle) file containing the set of the _ePO core definitions_, namely the classes and properties defined in ePO;
* ii) An OWL (Turtle) file containing the restrictions between classes that can be used for automatic inferencing, namely the axioms linking domain and range classes and literals, as well as the cardinalitie; and
* iii) A SHACL(Turtle) file containing data shapes that define further business and technical constraints, which can be used for automatic validation purposes.

This development is publicly available at this URL: [https://github.com/OP-TED/model2owl](https://github.com/OP-TED/model2owl).

Naming and design rules are tightly coupled, since the automation process expects the model to respect these rules in order to produce artefacts of quality and fully functional. These naming and design principles can be found in the documentation about the automated transformation of the UML into OWL, in these two documents:

* i) UML conventions: [https://github.com/OP-TED/model2owl/blob/master/doc/uml-conventions/uml-conventions.pdf](https://github.com/OP-TED/model2owl/blob/master/doc/uml-conventions/uml-conventions.pdf), and
* ii) Ontology architecture: [https://github.com/OP-TED/model2owl/blob/master/doc/ontology-architecture/ontology-architecture.pdf](https://github.com/OP-TED/model2owl/blob/master/doc/ontology-architecture/ontology-architecture.pdf)

Note, the automatic generation of the SHACL data shapes from the UML class attributes is currently disabled.  Thisis due to the necessity to perform a strict distinctions between properties that are meant to receive literal values, and those that receive object (URI) values. It is foreseen to carry on in the next version of the ontology a revision on 
  * usage of standard and custom data-types,
  * definition of complex data-types, and their declarations as classes, 
  * employment of properties as class attributes when they should be relations between classes.  
The automatic generation of the SHACL data shapes from the UML class relations is enabled as described in [The UML2OWL transformation rules](https://github.com/OP-TED/model2owl/blob/master/doc/uml2owl-transformation/uml2owl-transformation.pdf)
## III. Controlled vocabularies

Important decisions were also made regarding code-lists and taxonomies. From version 2.0.1 on, only two types of controlled vocabularies are proposed : those published on EU Vocabularies site and those defined during the development of the ePO. 

1. EU Vocabularies: code lists and taxonomies used within the ontology are publicly accessible at this Publications Office URL: https://op.europa.eu/en/web/eu-vocabularies/e-procurement/tables)

In the ePO UML diagrams, these code-list are identified with the prefix _at-voc_;

2. ePO code-lists: code lists are included in the ePO diagrams and can be easily identified as enumerations with the prefix _epo:_. They are procurement-specific and are currently being defined.

Concepts necessary in ePO that existed in other initiatives, e.g. codes from ESPD and eForms, have been either mapped to codes existing in EU Vocabularies or are currently
being integrated in the procurement-specific code-lists.

The transformation scripts support automatic generation of controlled vocabularies (code lists) from the UML model. It was decided, however, that the maintenance of the controlled lists employed in the eProcurement ontology to be done outside the UML model. The maintenance of the controlled lists currently is performed in conformance with teh processes employed by the EU-Vocabularies team at the OP. Therefore, the automatic generation of the formal structures  related to the controlled lists has been disabled. 

## IV. Terms of use

All the developments related to the ePO mentioned in these release notes are covered by the terms expressed in the EUPL Licence. See the COMMISSION IMPLEMENTING DECISION (EU) 2017/863, of 18 May 2017, updating the open source software licence EUPL to further facilitate the sharing and reuse of software developed by public administrations.

For details on the license see this URL: [https://eupl.eu/1.2/en/](https://eupl.eu/1.2/en/)
