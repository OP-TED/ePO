package epo.common;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Methods related to the transformation of an XML using and XSLT
 * @author mfontsan
 *
 */
public class XSLTTransformer{
	
	private static Logger log  = LogManager.getLogger(XSLTTransformer.class);
	private int idForm;
	private String 	tedToePO = null, tedXSD= null;
	private Transformer transformer = null;
	private int[] formsIDs = null;
	
	public XSLTTransformer() throws TransformerConfigurationException, TransformerFactoryConfigurationError {
		
		tedToePO = Properties.getProperty("TED_TO_EPO_XSL");
		tedXSD = Properties.getProperty("TED_EXPORT_XSD");
		
		Source xsl = new StreamSource(new File(tedToePO));
		transformer = TransformerFactory.newInstance().newTransformer(xsl);
		
		/*
		 * The forms to be transformed, i.e. upon which to generate a TTL file, are
		 * specified in the epo.properties files, under the /home/user directory. 
		 */
		StringTokenizer formsIDsTokenizer = new StringTokenizer(Properties.getProperty("DOCUMENT_TYPE_ID"), ",");
		
		this.formsIDs = new int[25];
		int i = 0;
		while(formsIDsTokenizer.hasMoreTokens()) {
			String token = formsIDsTokenizer.nextToken().trim();
			try {
				this.formsIDs[i++] = Integer.parseInt(token);
			} catch(NumberFormatException ne) {
				ne.printStackTrace();
			}
		}
	}
	
	/**
	 * Execute the transformation of the incoming XML using the tedToePO XSLT file.
	 * @param String: XML path to transform
	 */
	public String executeTransform(String xmlFile, String outputFilePathName){
		
		//log.info("Starting transformation. File to transform: " + xmlFile + ". FORM TYPE = " + this.getIdFormStr());		
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
	
	public String getIdFormStr() {
		return (idForm < 10 ? "F0" : "F") + idForm + "_2014";
	}
	public int getIdForm() {
		return idForm;
	}
	
	private boolean formIsToBeProcessed(int idForm) {
		int formsIDsListSize = this.formsIDs.length; 
		for(int i = 0; i < formsIDsListSize; i++) {
			if (idForm == this.formsIDs[i]) 
				return true;
		}
		return false;
	}
	/**
	 * Whether the input XML can be transformed or not. It validates the XML against the XSD
	 * @param String: XML file path
	 * @return Boolean: true is ready to transform, false it not ready to transform
	 */
	public boolean xmlReadyToTransform(String xmlFile) {
		
		boolean isReady = false;
		idForm = -1; // Reset to FORM FXX_2014 DOM Node is Empty.
		
		Source xmlSource = new StreamSource(new File(xmlFile));
	    
	    SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
	    
		try {
			Schema schema = schemaFactory.newSchema(new StreamSource(new File(tedXSD)));
			
			Validator validator = schema.newValidator();
			validator.validate(xmlSource);
			
			idForm = DOMnodeNotEmpty(xmlFile);
			
			if(idForm != -1 && this.formIsToBeProcessed(idForm)) {
				isReady = true;
			}else {
				isReady = false;
			}
			
		} catch (SAXException | IOException | ParserConfigurationException e) {
			// TED_EXPORT tag not found
			log.error(e.getLocalizedMessage() + String.format("File: %s", xmlFile)); 
			idForm = -1;
			isReady = false;
		}
		
		return isReady;
	}
	
	/*
	 * Creates a DOM doc NodeList per each type of Form. The NodeList will be checked for content inside the element
	 * with a particular FORM TYPE (tag FXX_2014). If the node is not empty and the FORM TYPE has been specified
	 * as one of the forms to be transformed and loaded (in the epo.properties file) the FORM is processed. Otherwise
	 * it is skipped.
	 * 
	 * @return the form ID if this form is in the list of forms to be processed or -1 otherwise.    
	 */
	private int DOMnodeNotEmpty(String xmlFile) throws SAXException, IOException, ParserConfigurationException {
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		Document doc = documentBuilderFactory.newDocumentBuilder().parse(new File(xmlFile));
	    
	    List<NodeList> nodeList = new ArrayList<NodeList>();
	    String tagName = "F";
	    
	    for(int i=1; i<=25; i++) {
	    	tagName = (i<10 ? "F0" : "F") + i + "_2014";
	    	nodeList.add(doc.getElementsByTagName(tagName));
	    }
	    
	    Iterator<NodeList> it = nodeList.iterator();
	    
	    for (int i = 1; i <= 25; i++) {
	    	NodeList n = it.next();
	    	if (n.getLength()> 0) 
	    		return i;
	    }
	    return -1;
	
	}
}
