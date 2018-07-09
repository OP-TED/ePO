package epo.common;

/**
 * Management of the TED XML files to be transformed
 * @author mfontsan
 *
 */
public class TedXMLFile {
	//private Logger log  = LogManager.getLogger(TedXMLFile.class);
	
	//Variables
	private String xmlFilepathName, xmlFileName;
	private boolean transformStatus = false;
	private boolean dbImportStatus = false;
	private String sparql;
	
	//Getters and setters
	
	public String getXmlFileName() {
		return xmlFileName;
	}
	public void setXmlFileName(String fileName) {
		this.xmlFileName = fileName;
	}
	public String getXmlFilePathName() {
		return xmlFilepathName;
	}
	public void setXmlFilePathName(String xmlFilePathName) {
		this.xmlFilepathName = xmlFilePathName;
	}
	public boolean isTransformStatus() {
		return transformStatus;
	}
	public void setTransformStatus(String transformMessage) {
		this.transformStatus = transformMessage != null ;
	}
	public boolean isDbImportStatus() {
		return dbImportStatus;
	}
	public void setDbImportStatus(boolean dbImportStatus) {
		this.dbImportStatus = dbImportStatus;
	}
	public String getSparql() {
		return sparql;
	}
	public void setSparql(String sparql) {
		this.sparql = sparql;
	}
}
