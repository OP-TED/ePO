package epo.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.util.StringTokenizer;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import epo.stax.Parser;
import epo.ted.stats.StatCodes;
import epo.ted.stats.Subsystem;
import net.sf.saxon.lib.FeatureKeys;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

/**
 * Methods related to the transformation of an XML using and XSLT
 * @author mfontsan
 *
 */
public class XSLTTransformer{
	private String 	tedToePO = null;
	private Transformer transformer = null;
	private String[] subsystemIDs = null;
	private String[] formsSchemaVersions = null;
	private String[] formIds = null;
	private Parser p = null;
	private XMLStreamReader reader = null;
	private Subsystem stats = null;
	
	public XSLTTransformer() throws TransformerConfigurationException, TransformerFactoryConfigurationError {
	
		tedToePO = Properties.getProperty("TED_TO_EPO_XSL");
		
		/*
		 * The Subsystem that produced the XML that are to be processed, e.g. TED_RECEPTION, TED_INTERNAL, TED_EXPORT.
		 * In principle the relevant ones should be the ones produced by TED_EXPORT, as these are the ones that are
		 * finally published in the TED Portal.
		 * @return the list of Subsystems
		 */
		subsystemIDs = getListFromProperties("TED_SUBSYSTEMS");
		/*
		 *  The different Version IDs of the TED-XML Subsystem Schemas that are to be processed,
		 *  e.g. R2.0.9.S01.E01, R2.0.9.S02.E01, etc.
		 *  <p> 
		 *  This is retrieved from the {@URL /home/user/epo.properties} file. 
		 */
		formsSchemaVersions = getListFromProperties("TED_XSD_VERSIONS");
		/*
		 * The types of forms to be transformed, i.e. upon which to generate a TTL file, are
		 * specified in the epo.properties files, under the /home/user directory.
		 * <p> 
		 * This is retrieved from the {@URL /home/user/epo.properties} file.
		 */
		formIds = getListFromProperties("TED_XSD_FORM_TYPES");
		
		Source xsl = new StreamSource(new File(tedToePO));
		TransformerFactory factory = TransformerFactory.newInstance();
		/**
		 * Otherwise the Release 2.0.9.S01.E1 provokes this warning 
		 * "SXXP0005: The source document is in namespace http://formex.publications.europa.eu/ted/schema/export/R2.0.9.S01.E01, but none of the
  		 * template rules match elements in this namespace (Use --suppressXsltNamespaceCheck:on to avoid this warning)
		 * See error explanation in {@URL https://stackoverflow.com/questions/33256226/warning-messages-appeared-after-upgrade-saxon-to-9-5-1-8}.
		 * Transformation XSL-Ts should be independent of the XSD Schema or select specific XSL-T per Schema, which right now is not the  case. 
		 */		
		factory.setFeature(FeatureKeys.SUPPRESS_XSLT_NAMESPACE_CHECK, true);
		transformer = factory.newTransformer(xsl);
		
		
	}
	
	private String[] getListFromProperties(String propertyName) {
		StringTokenizer st = new StringTokenizer(Properties.getProperty(propertyName), ",");
		
		String[] collection = new String[st.countTokens()];
		int i = 0;
		while(st.hasMoreTokens()) {
			collection[i++] = st.nextToken().trim();
		}
		return collection;
	}
	
	/**
	 * Execute the transformation of the incoming XML using the tedToePO XSLT file.
	 * @param String: XML path to transform
	 */
	public String executeTransform(String xmlFile, String outputFilePathName){
		
		String toRet = null;		
		Source xmlInput = new StreamSource(new File(xmlFile));
				
		Result xmlOutput = new StreamResult(new File(outputFilePathName));
		
		try {
				transformer.transform(xmlInput, xmlOutput); 
		} catch (TransformerException e) {
			toRet = e.getMessage();
		} 

		return toRet;
	}
	
	/**
	 * Validates the XML against the XSD and Whether the input XML is amongst the expected ones or not.
	 * @param String: XML file path
	 * @return Boolean: true is ready to transform, false it not ready to transform
	 */
	public boolean acceptableXMLToTransform(XMLInputFactory inputFactory, String xmlFile, Subsystem stats) {
		
		this.stats = stats;
		boolean isReady = false;
        try {
        	this.reader = inputFactory.createXMLStreamReader(new InputStreamReader(new FileInputStream(xmlFile)));
            isReady = readDocument();
        }catch (FileNotFoundException | XMLStreamException e) {
        	e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
					reader.close();
				} catch (XMLStreamException e) {
					e.printStackTrace();
				}
            }
        }		
		return isReady;
	}
	/**
	 * Generic internal method to check whether a String element is in a list or not.  
	 * @param container -> the list of Strings.
	 * @param element -> the element to search.
	 * @return -> true if found, false otherwise.
	 */
	private boolean contains(String[] container, String element) {
		
		for(int i = 0; i < container.length; i++) {
			if(element.toLowerCase().contains(container[i].toLowerCase()))
					return true;
		}
		return false;
	}
	/**
	 * Determines whether the root element of the XML file that is being processed is in the
	 * list of possible subsystems that produce XML, as specified in the {@URL /home/user/epo.properties} file.
	 * 
	 * @param rootElementName -> the name of the subsystem's envelope XSD root element.
	 * @return -> true if it is in the list, false otherwise.
	 */
	private boolean TED_XSD_SchemaIsOfExpectedSubsystem(String rootElementName) {
		return contains(this.subsystemIDs, rootElementName);
	}
	/**
	 * Determines whether the version of the XML file that is being processed is in the 
	 * list of possible versions that are to be processed, as specified in the {@URL /home/user/epo.properties} file.
	 * 
	 * @param TED_XSD_namespace
	 * @return
	 */
	private boolean TED_XSD_SchemaIsOfExpectedVersion(String TED_XSD_namespace) {
		return contains(this.formsSchemaVersions, TED_XSD_namespace);		
	}
	
	/**
	 * Gets the ID of the Form and determines whether it is one of the forms specified in the epo.properties file. Beware that relevant
	 * properties later on used from the TEDXMLProcess are initialised herein, namely formID and strIdForm, which are
	 * accessible via the public getters getIdFormStr() and getIdForm()
	 * @return true if the form is one of the expected ones or false if not.
	 */
	private boolean TED_XML_InstanceIsAnExpectedForm(String formId) {
			return contains(this.formIds, formId);
	}
	
	public Subsystem getStats() {
		return this.stats;
	}
	private boolean readDocument() {
		boolean isExpectedRoot = false, isExpectedXSD = false, isExpectedForm = false;
		
		p = new Parser(this.reader);
		
		String rootElementName = p.getRootElementName();
		String releaseId = p.getSchemaVersion();
		String formId = p.getFormType();
		
		isExpectedRoot= TED_XSD_SchemaIsOfExpectedSubsystem(rootElementName);
		isExpectedXSD = TED_XSD_SchemaIsOfExpectedVersion(releaseId);
		isExpectedForm = TED_XML_InstanceIsAnExpectedForm(formId);
		
		stats.getSnapshot().setSubsystemId(rootElementName);
		stats.getSnapshot().setReleaseID(releaseId);
		stats.getSnapshot().setFormId(formId);
		
		/*
		 * If the Release or the Form do not exist in the Subsystem they're created and added to it.
		 */
		stats.putRelease(releaseId);
		stats.getRelease(releaseId).putForm(formId);	
		
		if (isExpectedRoot && isExpectedXSD && isExpectedForm) { 
			stats.getForm(releaseId, formId).inc(StatCodes.PROCESSED);
			return true;
		}
		else 
			stats.getForm(releaseId, formId).inc(StatCodes.SKIPPED);
		
		return false;	
	}
}
