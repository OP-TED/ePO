package epo;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import epo.common.Arguments;
import epo.common.Properties;
import epo.common.opsCode;
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
	 */
	public static void main(String[] args){
		logger.info("Start ETL process...");
		startProcess(initArguments(args));
	}
	
	/**
	 * Initialization and processing of the arguments
	 * @param args: arguments as string
	 */
	public static opsCode initArguments(String[] args) {
	    Arguments argClass = new Arguments();
	    return argClass.parseArguments(args);
	}
	
	/*
	 * Gets the directory name of where the input data (e.g. the TED-XML instances of documents) are located. 
	 * This path is stored in a default epo.properties file that is located under the user's home folder.
	 * The property key is "INPUT_DATA_DIR", which points to a local file path. 
	 * Make sure that the application has "read" privileges on this folder.
	 */
	public static String getXMLResourcesDirPath() {
		
		/*
		 *  epo.common.Properties class. Reuses (does not inherit) java.util.Properties.
		 *  The epo.properties files contains the configuration data for the correct execution of the transformation,
		 *  and to access the remote graph store. It is expected to be located in the user home directory.
		 *  
		 */
		return Properties.getProperty("INPUT_DATA_DIR");
	}
	
	/**
	 * Initialization, start and end of the transformation process and importation to DB
	 */
	public static void startProcess(opsCode oc) {
		TedXMLProcess process = new TedXMLProcess();
		process.executeXSLTTransformation(oc);
	}
	
}