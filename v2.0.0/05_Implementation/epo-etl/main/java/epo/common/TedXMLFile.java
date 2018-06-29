package epo.common;

/**
 * Management of the TED XML files to be transformed
 * @author mfontsan
 *
 */
public class TedXMLFile {
	//private Logger log  = LogManager.getLogger(TedXMLFile.class);
	
	//Variables
	private String xmlFilename;
	private boolean transformStatus = false;
	private boolean dbImportStatus = false;
	private String sparql;
	
	//Getters and setters
	public String getXmlFilename() {
		return xmlFilename;
	}
	public void setXmlFilename(String xmlFilename) {
		this.xmlFilename = xmlFilename;
	}
	public boolean isTransformStatus() {
		return transformStatus;
	}
	public void setTransformStatus(boolean transformStatus) {
		this.transformStatus = transformStatus;
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
