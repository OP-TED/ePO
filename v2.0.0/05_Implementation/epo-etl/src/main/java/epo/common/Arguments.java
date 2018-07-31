package epo.common;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Management of the program arguments
 * @author mfontsan
 *
 */
public class Arguments {
	//Variables
	private Logger log  = LogManager.getLogger(Arguments.class);

	boolean hasArguments=false;

	/**
	 * Parse the incoming arguments into variables
	 */
	public opsCode parseArguments(String[] args){
		log.info("Parsing arguments...");
		
		String str1 = Arrays.toString(args);
		this.hasArguments = (checkArguments(str1.substring(1, str1.length()-1)) > 0);
		//String absolutePath = new File("").getAbsolutePath();

		for(int i=0; i<args.length; i++){
			String arg = args[i].trim();
			if(arg.equalsIgnoreCase("-a"))	return opsCode.ALL; // SPARQL INSERTS
			if(arg.equalsIgnoreCase("-t"))	return opsCode.TRANSFORM; // SPARQL INSERTS
			if(arg.equalsIgnoreCase("-i"))	return opsCode.INSERT; // SPARQL INSERTS
		}
		return opsCode.ALL;
	}
	
	/**
	 * Check that the permitted arguments are send: -xmlFolder or none. If not, the process is finalised.
	 * @author: Maria Font & Enric Staromiejski
	 * @update: 20180701
	 *
	 * Arguments:
	 * 	-t : execute the XSL-T transformations, but not the SPARQL Queries
	 * 	-i : execute the SPAQRL inserts, but not the transforemations
	 * 	-a : execute the transformations and the SPARQL queries
	 * 	no arguments: equals to "-a"
	 * 	Check also /home/user/epo.properties for the configuration of paths, proxy, graph store connection, etc.
	 */
	private int checkArguments(String stringArgs){

		int argsLength = stringArgs.length();
		if( argsLength !=0 &&
				!(
						 stringArgs.toLowerCase().contains("-a")  ||
						 stringArgs.toLowerCase().contains("-i")  ||
						 stringArgs.toLowerCase().contains("-t"))
				){
			exit();
		}
		return argsLength;
	}
	
	/**
	 * Validates the existance of the folder path send via parameter
	 * @return Boolean - whether the folder exists (true) or not (false)
	 */
	/*
	public boolean folderExist(){
		log.info("Validating the existance of the folder...");
		
		Path xmlPath = Paths.get(this.xmlFolderPath);
		
		if(Files.notExists(xmlPath)){
            log.werror("File: '"+xmlPath+"' does not exist.");
			System.exit(1);
		}

		log.info("Folder exists.");
		return true;
	}
	*/
	/**
	 * Stops the process
	 */
	private void exit(){
		String outputInformation = "";
		
		outputInformation += "\nNo valid options have been provided.\n";
		outputInformation += "Usage: [arg1] [xpath1]\n";
		outputInformation += "Valid arguments are:\n";
		outputInformation += "-a .... transforms XML into .txt files containing the SPARQL queries, but does not execute the queries. \n";
		outputInformation += "-i .... executes the SPARQL queries only. \n";
		outputInformation += "-a .... does everything. \n";
		
		outputInformation += "\nExamples:\n [-a] or [-t] or [i] (options are mutually exclusive. Only one option is accepted).\n";
		
		log.fatal(outputInformation);
		System.exit(1);
	}
	
	public boolean isHasArguments() {
		return hasArguments;
	}
}
