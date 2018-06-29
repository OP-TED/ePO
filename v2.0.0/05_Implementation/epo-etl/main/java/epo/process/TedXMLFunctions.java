package epo.process;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import epo.common.KBManagement;
//import epo.common.KBManagement;
import epo.common.TedXMLFile;

/**
 * Functions related to the TED XML files
 * @author mfontsan
 *
 */
public class TedXMLFunctions {
	private Logger log  = LogManager.getLogger(TedXMLFunctions.class);
	
	//Variables
	protected String folderXMLPath;
	protected List<TedXMLFile> xmlFiles;
	protected KBManagement graphDB;
	//protected KBManagement graphDB;
	
	
	/**
	 * Create an instance of TedXMLFile class
	 * @param File: file to save into the class
	 * @return TedXMLFile instance
	 */
	protected TedXMLFile createTedXMLFile(File f){
		TedXMLFile xmlFile = new TedXMLFile();
		xmlFile.setXmlFilename(f.getAbsolutePath());
		
		return xmlFile;
	}
	
	/**
	 * Get XML filenames from the directory folderXMLPath
	 */
	protected void getXMLFilesProcess() {
		File xmlDir = new File(this.folderXMLPath);
		this.xmlFiles = new ArrayList<TedXMLFile>();
		
		if(xmlDir.isDirectory()) {
			File[] xmlFiles = xmlDir.listFiles();
			
			for(int i=0; i<xmlFiles.length; i++) {		
				String extension = FilenameUtils.getExtension(xmlFiles[i].getName());
				
				if(extension.equals("xml")) {
					this.xmlFiles.add(createTedXMLFile(xmlFiles[i]));
				}
			}
			log.info("There are '"+this.xmlFiles.size()+"' XML files to process.");
		}else {
			log.error("Directory: '"+xmlDir+"' does not exist.");
		}
	}
	
	
	//Getters and setters
	public String getFolderXMLPath() {
		return folderXMLPath;
	}


	public void setFolderXMLPath(String folderXMLPath) {
		this.folderXMLPath = folderXMLPath;
	}


	public List<TedXMLFile> getXmlFiles() {
		return xmlFiles;
	}


	public void setXmlFiles(List<TedXMLFile> xmlFiles) {
		this.xmlFiles = xmlFiles;
	}

}
