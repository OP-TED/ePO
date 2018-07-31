package epo.process;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Iterator;

import javax.xml.stream.XMLInputFactory;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import epo.common.FileCompiler;
import epo.common.KBManagement;
import epo.common.Properties;
import epo.common.TedXMLFile;
import epo.common.XSLTTransformer;
import epo.common.opsCode;
import epo.ted.stats.Form;
import epo.ted.stats.Stat;
import epo.ted.stats.StatCodes;
import epo.ted.stats.Subsystem;

/**
 * Functions related to the extraction, transformation and loading process
 * @author mfontsan
 *
 */
public class TedXMLProcess extends TedXMLFunctions{
	private Logger log  = LogManager.getLogger(TedXMLProcess.class);
	private String output_sparql_filename = null;
	private Stat tStat = null, iStat = null;
	
	/**
	 * TedXMLProcess Constructor
	 */
	public TedXMLProcess() {
		super();
		
		this.output_sparql_filename = Properties.getProperty("OUTPUT_DATA_DIR");
		
		String logDir = Properties.getProperty("LOG_DATA_DIR");
		String logFileName = logDir + "/" + "ePO_" +  new SimpleDateFormat("yyyyMMdd_HHmmss").format(Calendar.getInstance().getTime()) + ".log";
		System.setProperty("logFilename", logFileName);
		
			org.apache.logging.log4j.core.LoggerContext ctx =
			    (org.apache.logging.log4j.core.LoggerContext) LogManager.getContext(false);
			ctx.reconfigure();
	}
	
	/**
	 * This is a very control private method to display the number of files to be processed in one way or another. 
	 * @param arg If the argument is "-t" it means that the process to execute is ONLY transformation, otherwise it's SPARQL INSERT
	 */
	private long fileCompiling(String arg) {
		long totalRead = 0;
		log.info("Compiling input data files...");
		if (arg.equalsIgnoreCase("-t")) totalRead= getXMLFilesToProcess(this.folderXMLPath);
		else totalRead = new FileCompiler(arg).FileCount(); 
		log.info("-------------------------------------------------------------------------");
		log.info("Total files compiled: " + totalRead);
		log.info("-------------------------------------------------------------------------");
		return totalRead;
	}
	
	/**
	 * Execution of the process to transform TED XML into SPARQL queries
	 */
	public void executeXSLTTransformation(opsCode code) {
		this.folderXMLPath = Properties.getProperty("INPUT_DATA_DIR");
		
		switch (code){
			case ALL: log.info("Transforming AND Inserting triples in the Graph db.");
					log.info("TRANSFORMATION STARTS NOW ...");
					tStat = new Stat("Transformed");
					iStat = new Stat("Inserted");
					tStat.setCompiled(fileCompiling("-t"));
					startXSLTTransformation(); 
					log.info("SPARQL INSERTION STARTS NOW ...");
					iStat.setCompiled(fileCompiling(this.output_sparql_filename));
					startGraphDBImport(); 
					break;
			case TRANSFORM: log.info("Transforming ONLY");
					log.info("TRANSFORMATION STARTS NOW ...");
					tStat = new Stat("Transformed");
					startXSLTTransformation(); 
					break;
			case INSERT: log.info("Inserting triples in the Graph db ONLY."); 
					log.info("SPARQL INSERTION STARTS NOW ...");
					iStat = new Stat("Inserted");
					iStat.setCompiled(fileCompiling(this.output_sparql_filename));
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
						iStat.inc(StatCodes.PROCESSED);
					}catch (Exception e) {
						iStat.inc(StatCodes.SKIPPED);
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
		graphDB.setTotalFilesToInsert(iStat.getCompiled());
		graphDB.initGraphDBRepository();
		
		this.executeSPARQL(sparqlDir);
		
		graphDB.shutDownGraphDB();
		
		writeToLog(iStat);
		
	}
	
	private void writeToLog(Stat stat) {
		log.info(	"\n\n" + 
				"Total files compiled: " +
				stat.getCompiled() +
				", read: " +
				stat.getRead() +
				", successfully inserted: " +
				stat.getProcessed() + 
				", skipped: " + 
				stat.getSkipped());
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
		
		/*
		 * Statistics: The class Subsystem is the root of a vocabulary Subsystem->n Releases -> n Forms, where 
		 * the data about the different types of XSD Schemas, versions, types of forms and number of forms are kept.
		 *  
		 */
		Subsystem stats = new Subsystem("TED_EXPORT");
		
		XMLInputFactory inputFactory = XMLInputFactory.newInstance();
		
		while(itFiles.hasNext()){
			TedXMLFile f = itFiles.next();
			String xmlFileName = f.getXmlFileName();
			String xmlFilePathName = f.getXmlFilePathName();
		
			outputFilePathName = outputDirectory + "/" + xmlFileName + "_output.txt";
			
			boolean readyToTransform = transformer.acceptableXMLToTransform(inputFactory, xmlFilePathName, stats);
			
			if(readyToTransform) {
				f.setTransformStatus(transformer.executeTransform(xmlFilePathName, outputFilePathName));	
				stats.inc(StatCodes.PROCESSED);
				tStat.inc(StatCodes.PROCESSED);
			}else {
				stats.inc(StatCodes.SKIPPED);
				tStat.inc(StatCodes.SKIPPED);
			}
			
			log.info(
					"Transformation of file: " + xmlFileName + " - " +
					(readyToTransform ? "SUCCESSFULLY EXECUTED - " : "OPERATION SKIPPED - ") + 
					"[" + tStat.getRead() + "/"+ tStat.getCompiled() + "]. " +
					"FORM INFO: " + 
					"[XSD_SUBSYSTEM: " + stats.getSnapshot().getSubsystemId() + "]" +		
					"[XSD_RELEASE: " + stats.getSnapshot().getReleaseId() + "]" +
					"[FORM_TYPE: " + stats.getSnapshot().getFormId() + "]" 
					);	
		}
		logFinalStatistics(transformer.getStats(), tStat);
	}	
	
	private void logFinalStatistics(Subsystem stats, Stat generalStats) {
		Stat oneFormTotals = null;
		Hashtable<String, Stat> formTypesTable = new Hashtable<String, Stat>();
		
		log.info("\n\n------------ TOTALS per RELEASE ----------------");
		Iterator<String> rit = stats.getReleases().keySet().iterator();
		while(rit.hasNext()) {
			String releaseId = rit.next();
			log.info("\n\n------------ RELEASE: " + releaseId + "----------------\n");
			Iterator<String> fid = stats.getRelease(releaseId).getForms().keySet().iterator(); 
			while (fid.hasNext()) {
				String formId = fid.next();
				Form f = stats.getForm(releaseId, formId);
				
				oneFormTotals = formTypesTable.get(formId);
				
				if( oneFormTotals == null)
				{	
					oneFormTotals = new Stat("Transformed");
					oneFormTotals.setProcessed(f.getProcessed());
					oneFormTotals.setSkipped(f.getSkipped());
				}else {
					oneFormTotals.setProcessed(oneFormTotals.getProcessed() + f.getProcessed());
					oneFormTotals.setSkipped(oneFormTotals.getSkipped() + f.getSkipped());
				}
				formTypesTable.put(formId, oneFormTotals);
				
				log.info(
						"FORM TYPE: " + f.getId() + 	
						", Total " + oneFormTotals.getId() + ": " + f.getProcessed() +
						", Total skipped " + f.getSkipped()
					);
			}
		}

		log.info("\n\n------------ TOTALS per FORM TYPE ----------------");
		Iterator<String> iftt = formTypesTable.keySet().iterator();
		while(iftt.hasNext()) {
			String key = iftt.next();
			Stat s = formTypesTable.get(key);
			log.info("FORM TYPE " + key + ": " + 
					 	" Total " + oneFormTotals.getId()+ ": " + s.getProcessed() +
						", Total Skipped: " + s.getSkipped() +
						", Total Compiled: " + (s.getProcessed() + s.getSkipped())
					);
		}
		
		log.info("\n\n------------ TOTALS  ----------------");
		log.info(" Total Compiled: " + generalStats.getCompiled());
		log.info(" Total " + generalStats.getId() + ": " + generalStats.getProcessed());
		log.info(" Total Skipped: " + generalStats.getSkipped());
	}
}
