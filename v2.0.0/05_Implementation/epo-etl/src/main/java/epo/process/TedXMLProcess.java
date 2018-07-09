package epo.process;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import epo.common.FileCounter;
import epo.common.KBManagement;
import epo.common.Properties;
import epo.common.TedXMLFile;
import epo.common.XSLTTransformer;

/**
 * Functions related to the extraction, transformation and loading process
 * @author mfontsan
 *
 */
public class TedXMLProcess extends TedXMLFunctions{
	private Logger log  = LogManager.getLogger(TedXMLProcess.class);
	private String output_sparql_filename = null;
	private long notTransformed = 0, transformed = 0; // Transformations statistics control
	static int ALL = 0, TRANSFORM = 1, INSERT = 2;
	private long totalSuccessfullyInserted, totalSkipped, totalCompiled; // SPARQL INSERTS statistics control
	/*
	 * processCode values are 0, 1 or 2, meaning do everything (ALL), transform (TRANSFORM) OR execute INSERT SPARQL queries (INSERT);
	 */
	int 	processCode = 0;

	/**
	 * TedXMLProcess Constructor
	 */
	public TedXMLProcess() {
		super();
		this.output_sparql_filename = Properties.getProperty("OUTPUT_DATA_DIR");
		
		String logFileName = "ePO_" +  new SimpleDateFormat("yyyyMMdd_HHmmss").format(Calendar.getInstance().getTime()) + ".log";
		System.setProperty("logFilename", logFileName);
		
			org.apache.logging.log4j.core.LoggerContext ctx =
			    (org.apache.logging.log4j.core.LoggerContext) LogManager.getContext(false);
			ctx.reconfigure();
	}
	
	/**
	 * This is a very control private method to display the number of files to be processed in one way or another. 
	 * @param arg If the argument is "-t" it means that the process to execute is ONLY transformation, otherwise it's SPARQL INSERT
	 */
	private void fileCompiling(String arg) {
		log.info(String.format("Compiling input data files..."));
		if (arg.equalsIgnoreCase("-t")) totalCompiled = getXMLFilesProcess(this.folderXMLPath);
		else totalCompiled = new FileCounter(arg).FileCount(); 
		log.info("-------------------------------------------------------------------------");
		log.info(String.format("Total files compiled: %d.", totalCompiled));
		log.info("-------------------------------------------------------------------------");
	}
	
	/**
	 * Execution of the process to transform TED XML into SPARQL queries
	 */
	public void executeXSLTTransformation(int processCode) {
		this.folderXMLPath = Properties.getProperty("INPUT_DATA_DIR");
		switch (processCode){
			case 0: log.info("Transforming AND Inserting triples in the Graph db.");
					fileCompiling("-t");
					startXSLTTransformation(); 
					fileCompiling(this.output_sparql_filename);
					startGraphDBImport(); 
					break;
			
			case 1: log.info("Transforming ONLY");
					fileCompiling("-t");
					startXSLTTransformation(); 
					break;
			
			case 2: log.info("Inserting triples in the Graph db ONLY."); 
					fileCompiling(this.output_sparql_filename);
					startGraphDBImport(); 
					break;
		}
	}
	
	/*
	 * Recursive method for the collection of TXT files and execution of the SPARQL INSERT patterns.
	 */
	private void executeSPARQL(File file) {
		
				File[] sparqlFiles = file.listFiles();
				
				for(int i = 0; i < sparqlFiles.length; i++) {		
					if(sparqlFiles[i].isDirectory()) this.executeSPARQL(sparqlFiles[i]);
					else {
						String extension = FilenameUtils.getExtension(sparqlFiles[i].getName());
						
						if(extension.equals("txt")) {
							try {
								graphDB.readAndExecuteSPARQL(sparqlFiles[i]);
								++totalSuccessfullyInserted;
							}catch (Exception e) {
								++totalSkipped;
							}
						}
					}
				}
	}
	
	/**
	 * Process to import each of the TED XML transformed files into the GraphDB
	 */
	private void startGraphDBImport() {
		
		/*
		 * 1. For each *.txt file
		 * 2. Read TXT file
		 * 3. Execute query into GraphDB
		 */
		File sparqlDir = new File(output_sparql_filename);
		
		graphDB = new KBManagement();
		graphDB.setTotalFilesToInsert(totalCompiled);
		graphDB.initGraphDBRepository();
		
		this.executeSPARQL(sparqlDir);
		
		graphDB.shutDownGraphDB();
		log.info("\n\n" + String.format("Total files compiled: %d\nTotal files successfully inserted: %d\nTotal files skipped:%d", totalCompiled, totalSuccessfullyInserted, totalSkipped)); 
		
	}
	
	/**
	 * Execute the XSLT transformation
	 */
	private void startXSLTTransformation() {
		
		System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
		Iterator<TedXMLFile> itFiles = this.xmlFiles.iterator();
		
		XSLTTransformer transformer = null;
		try {
			transformer = new XSLTTransformer();
		} catch(TransformerConfigurationException | TransformerFactoryConfigurationError e) {
			e.printStackTrace();
			System.exit(1);
		}
		
		String outputDirectory = Properties.getProperty("OUTPUT_DATA_DIR") + "/" + "OUTPUT_" + new java.util.GregorianCalendar().getTimeInMillis() ;
		String outputFilePathName = null;
		String formID = "";
		long totalFilesProcessed = 0;

		// Each form and the number of its occurrences is saved into an array. This table will be used at the end for statistical purposes.
		long forms[] = new long[26]; // 25 2014-FORMS + OTHER (NON TED_EXPORT TAG)
		
		while(itFiles.hasNext()){
			TedXMLFile f = itFiles.next();
			String xmlFileName = f.getXmlFileName();
			String xmlFilePathName = f.getXmlFilePathName();
			
			++totalFilesProcessed;
			
			outputFilePathName = outputDirectory + "/" + xmlFileName + "_output.txt";
			
			boolean readyToTransform = transformer.xmlReadyToTransform(xmlFilePathName);
			formID = transformer.getIdFormStr();
			
			if(readyToTransform) {
				log.info("Transformation of file: " + xmlFileName + " - SUCCESSFULLY EXECUTED - [" + totalFilesProcessed + "/"+ totalCompiled + "]. FORM TYPE = " + formID);
				f.setTransformStatus(transformer.executeTransform(xmlFilePathName, outputFilePathName));	
				++transformed;
			}else {
			
				if (transformer.getIdForm() == -1) formID = "OTHER"; // NOT A TED_EXPORT ENVELOPPED NOTICE.
				log.warn("XML SKIPPED. The XML '" + xmlFileName + "' WON'T BE TRANSFORMED - [" + totalFilesProcessed + "/" + totalCompiled + "]. FORM TYPE = " + formID); 
						 
				notTransformed++;
			}
	
			// Increment the type of form that has been processed, either if it has been transformed or not.
			int curFormID = transformer.getIdForm();
			if (curFormID > 0) {
				long curFormCount = forms[curFormID-1];
				forms[curFormID-1] = ++curFormCount;
			}else // -1 flag indicates "OTHER" (NON TED_XML TAG).
				forms[forms.length-1] += 1;
		}
			log.info(String.format("Total files examined: %d, total transformed: %d, total skipped: %d", 
					totalFilesProcessed, transformed, notTransformed));
			
			// The extension .csv aims to facilitate the production of graphics easily.
			String statsFilePathName = "stats-" + new java.util.GregorianCalendar().getTimeInMillis() + ".log.csv"; 
			logFinalStatistics(forms, statsFilePathName);
	}	
	
	private void logFinalStatistics(long forms[], String statsFilePathName) {
		
		PrintWriter pw = null;
		String toWrite = null;
		
		try {
			
			pw = new PrintWriter(new FileWriter(statsFilePathName));
			
			System.out.println("\nStatistics\n---------------------------\n");
			
			pw.println("Form type;Form quantity");
			
			for(int i = 0; i < forms.length-1; i++) {
				
				toWrite = (i < 9 ? "F0" : "F") + (i+1) + "_2014;" + forms[i];
				System.out.println(toWrite);
				pw.println(toWrite);
			}
			System.out.println("OTHER;" + forms[forms.length-1]);
			pw.println("OTHER;" + forms[forms.length-1]);
		}catch (IOException io) {
			io.printStackTrace();
		}
		pw.close();
	}
}
