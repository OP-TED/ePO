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
		
	public TedXMLFunctions() {
		this.xmlFiles = new ArrayList<TedXMLFile>();
	}
	
	/**
	 * Create an instance of TedXMLFile class
	 * @return TedXMLFile instance
	 */
	protected TedXMLFile createTedXMLFile(File f){
		TedXMLFile xmlFile = new TedXMLFile();
		xmlFile.setXmlFilePathName(f.getAbsolutePath());
		xmlFile.setXmlFileName(f.getName());
		
		return xmlFile;
	}
	
	/**
	 * Get XML filenames from the directory folderXMLPath
	 */
	protected long getXMLFilesToProcess(String folderXMLPath) {
		
		File xmlDir = new File(folderXMLPath);
		
		if(xmlDir.isDirectory()) {
			
			File[] _xmlFiles = xmlDir.listFiles();
			
			for(int i=0; i<_xmlFiles.length; i++) {		
			
				String filePathName = _xmlFiles[i].getAbsoluteFile().getAbsolutePath();
					if (new File(filePathName).isDirectory()) {
						this.getXMLFilesToProcess(filePathName);
					} else {
						String name = FilenameUtils.getName(_xmlFiles[i].getName());
						String extension = FilenameUtils.getExtension(_xmlFiles[i].getName());
						if(extension.equalsIgnoreCase("xml")) {
							this.xmlFiles.add(createTedXMLFile(_xmlFiles[i]));
							//log.info(String.format("Compiling input data file: %s.", name));
					}					
				}				
			}			
		}
		// Returns the total number of files compiled in the List.
		return this.xmlFiles.size();
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
