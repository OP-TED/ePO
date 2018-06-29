package epo.process;

import java.io.File;
import java.util.Iterator;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import epo.common.KBManagement;
import epo.common.TedXMLFile;
import epo.common.XSLTTransformer;

/**
 * Functions related to the extraction, transformation and loading process
 * @author mfontsan
 *
 */
public class TedXMLProcess extends TedXMLFunctions{
	private Logger log  = LogManager.getLogger(TedXMLProcess.class);
	
	private String output_sparql_filename= "src/test/resources/output";
	
	/**
	 * TedXMLProcess Constructor
	 * @param String: Folder path containing all TED XML
	 */
	public TedXMLProcess(String folderXMLPath) {
		super();
		this.folderXMLPath = folderXMLPath;		
	}
	
	/**
	 * Execution of the process to transform TED XML into SPARQL queries
	 */
	public void executeXSLTTransformation() {
		getXMLFilesProcess();
		startXSLTTransformation();
		startGraphDBImport();
	}
	
	/**
	 * Process to import each of the TED XML transformed files into the GraphDB
	 */
	private void startGraphDBImport() {
		//graphDB = new KBManagement();
		graphDB = new KBManagement();
		graphDB.initGraphDBRepository();
		
		
		
		/*
		 * 1. For each src\test\resources\output\*.txt file
		 * 2. Read TXT file
		 * 3. Execute query into GraphDB
		 */
		File sparqlDir = new File(this.output_sparql_filename);
		if(sparqlDir.isDirectory()) {
			File[] sparqlFiles = sparqlDir.listFiles();
			
			for(int i=0; i<sparqlFiles.length; i++) {		
				String extension = FilenameUtils.getExtension(sparqlFiles[i].getName());
				
				log.info("Starting query file: " + sparqlFiles[i].getName());
				
				if(extension.equals("txt")) {
					graphDB.readAndExecuteSPARQL(sparqlFiles[i]);
				}
			}
		}else {
			log.error("Error getting the SPARQL queries from the directory: " + this.output_sparql_filename);
		}
		
		graphDB.shutDownGraphDB();
	}
	
	/**
	 * Execute the XSLT transformation
	 */
	private void startXSLTTransformation() {
		System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
		
		Iterator<TedXMLFile> itFiles = this.xmlFiles.iterator();
		
		int notTransformed = 0;
		
		while(itFiles.hasNext()){
			TedXMLFile f = itFiles.next();
			
			if(XSLTTransformer.xmlReadyToTransform(f.getXmlFilename())) {
				f.setTransformStatus(XSLTTransformer.executeTransform(f.getXmlFilename()));
			}else {
				log.error("XML SKIPPED. The XML '" + f.getXmlFilename() + "' cannot be transformed.");
				notTransformed++;
			}
		}
		
		log.info("Number of notices not transformed: " + notTransformed);
	}
	
}
