package epo;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import epo.common.Arguments;
import epo.process.TedXMLProcess;

/**
 * Main Extraction, Transformation and Load class
 * @author mfontsan
 *
 */
public class MainETLProcess {
	private static Logger logger = LogManager.getLogger(MainETLProcess.class);

	/**
	 * Access point
	 * @param String[] - arguments, if need it.
	 */
	public static void main(String[] args){
		logger.info("Start ETL process...");
		
		String dirPath = initArguments(args);
		startProcess(dirPath);
	}
	
	/**
	 * Initialization and processing of the arguments
	 * @param args: arguments as string
	 */
	public static String initArguments(String[] args) {		
	    Arguments argClass = new Arguments();
	    argClass.parseArguments(args);
	    
	    if(!argClass.isHasArguments()) {
	    	argClass.setXmlFolderPath("src/test/resources/xml_samples");
	    }
	    
	    argClass.folderExist();
	    return argClass.getXmlFolderPath();
	}
	
	/**
	 * Initialization, start and end of the transformation process and importation to DB
	 * @param dirPath
	 */
	public static void startProcess(String dirPath) {
		TedXMLProcess process = new TedXMLProcess(dirPath);
		process.executeXSLTTransformation();
	}
	
}