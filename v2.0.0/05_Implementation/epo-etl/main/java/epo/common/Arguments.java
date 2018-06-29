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
	
	String xmlFolderPath;
	boolean hasArguments=false;

	/**
	 * Parse the incoming arguments into variables
	 * @param String[] - Incoming arguments
	 */
	public void parseArguments(String[] args){
		log.info("Parsing arguments...");
		
		String str1 = Arrays.toString(args);         
		checkArguments(str1.substring(1, str1.length()-1));
		String absolutePath = new File("").getAbsolutePath();
		
		for(int i=0; i<args.length; i++){
			String arg = args[i].trim();
			
			if(arg.equalsIgnoreCase("-xmlFolder")){
				this.xmlFolderPath = absolutePath+args[++i];
				this.xmlFolderPath = args[++i];
				this.hasArguments = true;
			}
		}
	}
	
	/**
	 * Check that the permitted arguments are send: -xmlFolder or none. If not, the process is finalised.
	 * @param String - Incoming arguments as string
	 */
	private void checkArguments(String stringArgs){
		if(stringArgs.length()!=0 && !stringArgs.toLowerCase().contains("-xmlFolder")){
			exit();
		}
	}
	
	/**
	 * Validates the existance of the folder path send via parameter
	 * @return Boolean - whether the folder exists (true) or not (false)
	 */
	public boolean folderExist(){
		log.info("Validating the existance of the folder...");
		
		Path xmlPath = Paths.get(this.xmlFolderPath);
		
		if(Files.notExists(xmlPath)){
            log.error("File: '"+xmlPath+"' does not exist.");
			System.exit(1);
		}

		log.info("Folder exists.");
		return true;
	}
	
	/**
	 * Stops the process
	 */
	private void exit(){
		String outputInformation = "";
		
		outputInformation += "\nNo valid options have been provided.\n";
		outputInformation += "Usage: [arg1] [xpath1]\n";
		outputInformation += "The argument is:\n";
		outputInformation += "-xmlFolder .......................[XML Folder to be transformed]\n";
		
		outputInformation += "\nExamples:\n -xml 'Folder path'\n";
		
		log.fatal(outputInformation);
		System.exit(1);
	}
	

	//Getters and setters
	public String getXmlFolderPath() {
		return xmlFolderPath;
	}

	public void setXmlFolderPath(String xmlFolderPath) {
		this.xmlFolderPath = xmlFolderPath;
	}

	public boolean isHasArguments() {
		return hasArguments;
	}

	public void setHasArguments(boolean hasArguments) {
		this.hasArguments = hasArguments;
	}
}
