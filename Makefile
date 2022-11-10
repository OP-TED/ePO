########################################################################################################
#@author: Duy DINH
#@date: Oct. 2022
#@pre-conditions: 
# We suppose that you already clone the model2owl using github command line below
# $ git clone https://github.com/OP-TED/model2owl.git
#
# After cloning into your local repository
# $ cd model2owl
#
# To see the content of the Makefile, please use the command below
# $ less Makefile
#
########################################################################################################
#curBranch := $(shell git branch --show-current)
curBranch := $(shell git rev-parse --abbrev-ref HEAD)
# Number of file under .git repo (to test if the git repo was already cloned)
gitRepoFiles :=  $(shell ls -l transform/model2owl/.git >/dev/null 2>&1 | wc -l )
secrets.GITHUB_TOKEN := *******

# Model2owl directory
MODEL2OWL_DIR?="transform/model2owl"
# Project directory, ie. directory where we store the input/output from model2owl
PROJECT_DIR?="transform"
# One of the xmi input files to be merged into a single UML xmi/xml file
FIRST_INPUT_XMI_FILE?="implementation/ePO/xmi_conceptual_model/ePO_CM.xml"
# Input dir containing files to be merged
INPUT_XMI_DIR?=$(shell dirname ${FIRST_INPUT_XMI_FILE})
# rdflib version
RDF_LIB_VERSION?=6.2.0
SAXON="transform/saxon-he-10.6.jar"
# Output directory containing combined file from multiple xmi / xml UML models
COMBINED_XMI_DIRECTORY?="implementation/ePO/xmi_conceptual_model/combined-xmi"
COMBINED_FILE_NAME?=ePO-combined.xmi
#XMI_DIRECTORY?="../implementation/ePO/xmi_conceptual_model/combined-xmi"
# Glossary output directory
OUTPUT_GLOSSARY_PATH?="glossary"

# Input XMI/XML UML file path
UML_INPUT_FILENAME?="implementation/ePO/xmi_conceptual_model/combined-xmi/ePO-combined.xmi"
filename=$(shell basename -- "${UML_INPUT_FILENAME}") 
UML_FILENAME_WITHOUT_EXTENSION=$(shell echo ${filename} | cut -f1 -d '.')


OUTPUT_CORE_FILE_NAME?="ePO_CM-core.rdf"
OUTPUT_RESTRICTIONS_FILE_NAME?="ePO_CM-restrictions.rdf"
OUTPUT_SHACL_SHAPES_FILE_NAME?="ePO_CM-shacl.rdf"

# Output ontologies
OUTPUT_PATH_OWL?="../output/epo-ontologies"
RDF_DIR?=${OUTPUT_PATH_OWL}
FILELIST=$(shell ls ${RDF_DIR}/*.rdf)
# download saxon library 	
get-saxon:
	@mkdir -p ${PROJECT_DIR}
	@cd ${PROJECT_DIR}  && curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip

# Clone model2owl if the directory model2owl does not exist
get-model2owl-repo:
	@cd ${PROJECT_DIR} && git clone https://github.com/OP-TED/model2owl.git
	
# download xspec framework to run unit tests
get-xspec:	
	@cd ${PROJECT_DIR}  && rm -rf xspec && curl -L -o xspec.zip https://github.com/xspec/xspec/archive/refs/tags/v2.2.4.zip && unzip xspec.zip -d model2owl && rm -rf xspec.zip && cd model2owl && ln -s xspec-* xspec

# install rdflib
get-rdflib:
	@echo please activate your virtual env first using the commands below
	@echo -- Create an virtual environment    
	@echo pip install virtualenv
	@echo virtualenv venv
	@echo -- Activate your venv
	@echo source venv/bin/activate
	@echo -- Install rdflib inside your virtual environment
	@pip install rdflib
	

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
init:  get-saxon get-rdflib

############################ Main tasks ##############################################
# Run unit_tests
unit-tests:
	@ant -lib ${SAXON} unit_tests

# Combine xmi UML files
merge-xmi:
	@mkdir -p ${COMBINED_XMI_DIRECTORY}
	@java -jar ${SAXON} -s:${FIRST_INPUT_XMI_FILE} -xsl:${MODEL2OWL_DIR}/src/xml/merge-multi-xmi.xsl -o:${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}
	@echo Input files to be combined are located at the directory containing this input file: ${FIRST_INPUT_XMI_FILE} under directory ${INPUT_XMI_DIR}
	@ls -lh ${INPUT_XMI_DIR}
	@echo 
	@echo "==> The combined document is located at the following location" 
	@ls -lh ${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}

# Generate the glossary from an input file
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@echo Input: ${UML_INPUT_FILENAME}
	@echo Input without extension: ${UML_FILENAME_WITHOUT_EXTENSION}
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/html-model-glossary.xsl -o:${OUTPUT_GLOSSARY_PATH}/${UML_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo The combined glossary is located at the following location:
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/${UML_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo
	 

owl-core:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/owl-core.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_CORE_FILE_NAME}
	@echo Output owl core file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_CORE_FILE_NAME}
owl-restrictions:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/owl-restrictions.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_RESTRICTIONS_FILE_NAME}
    @echo Output owl restrictions file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_RESTRICTIONS_FILE_NAME}
shacl:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/shacl-shapes.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_SHACL_SHAPES_FILE_NAME}
	@echo Output shacl file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_SHACL_SHAPES_FILE_NAME}

transform: owl-core owl-restrictions shacl
convert-to-turtle:
	@for filename in ${FILELIST}; do \
		echo Converting $${filename}; \
		rdfpipe -i application/rdf+xml -o  turtle $${filename} > $${filename%.*}.ttl; \
		echo Input in RDF/XML format;  \
		ls -lh $${filename};  \
		echo " ==> Output in Turtle format";  \
		ls -lh $${filename%.*}.ttl;  \
	done
#@for filename in $$(ls $$FILELIST ); do echo Converting ${filename}; python3 scripts/rdfxml2turtle.py --input  ${filename} --output ${filename%.*}.ttl;  echo Input in RDF/XML format;  ls -lh ${filename};  echo Output in Turtle format;  ls -lh ${filename%.*}.ttl;  done;
help:
	@echo The automatic tasks available are defined as below
	@echo "\$$ Command line # Description"
	@echo
	@echo "\$$ make merge-xmi # to combine multiple input files (*.xmi, *.xml)"
	@echo Variables:
	@echo FIRST_INPUT_XMI_FILE=[first xmi or xml filename]
	@echo COMBINED_XMI_DIRECTORY=[the directory containing the output combined or merged XMI file.]
	@echo COMBINED_FILE_NAME=[the filename of the combined or merged XMI files, e.g. combined.xmi]
	@echo
	@echo "\$$ make generate-glossary # to generate the glossary from an input file"	
	@echo Variables:
	@echo UML_INPUT_FILENAME=[the path to the xmi or xml UML input file.]	
	@echo OUTPUT_GLOSSARY_PATH=[the output directory containing the glossary]
	@echo "\$$ make transform # transform from XMI/XML UML into RDF/XML (core, restrictions and shacl)"
	@echo
	@echo "\$$ make convert-to-turtle # convert RDF/XML files from an input folder into Turtle format"
	@echo Variables:
	@echo RDF_DIR=[Directory containing RDF/XML files to be converted into Turtle format]
	@echo "\$$ # "

h: help	
usage: help
default: help