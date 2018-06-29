package epo.common;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
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
	
	//Variables
	private static String tedToePO = "src/main/resources/xslt/TEDXSD_to_ePOTTL.xsl";
	private static String tedXSD = "src/main/resources/TED_publication_R2.0.9.S02.E01_003-20170123/TED_EXPORT.xsd";
	
	
	/**
	 * Execute the transformation of the incoming XML using the tedToePO XSLT file.
	 * @param String: XML path to transform
	 */
	public static boolean executeTransform(String xmlFile){
		//log.info("Starting transformation. File to transform: " + xmlFile);		
				
		Source xmlInput = new StreamSource(new File(xmlFile));
		Source xsl = new StreamSource(new File(tedToePO));
		Result xmlOutput = new StreamResult(new File(xmlFile + "_output.txt"));

		try {
		    javax.xml.transform.Transformer transformer = TransformerFactory.newInstance().newTransformer(xsl);
		    transformer.transform(xmlInput, xmlOutput);
		} catch (TransformerException e) {
			//log.error("Error during the transformation: "+ e.getMessage());
			
			return false;
		}
		
		
		//log.info("Transformation done.");
		return true;
	}
	
	/**
	 * Whether the input XML can be transformed or not. It validates the XML against the XSD
	 * @param String: XML file path
	 * @return Boolean: true is ready to transform, false it not ready to transform
	 */
	public static boolean xmlReadyToTransform(String xmlFile) {
		boolean isReady = false;
		
		Source xmlSource = new StreamSource(new File(xmlFile));
	    
	    SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
	    
		try {
			Schema schema = schemaFactory.newSchema(new StreamSource(new File(tedXSD)));
			
			Validator validator = schema.newValidator();
			validator.validate(xmlSource);
			
			if(isContractAwardNotice(xmlFile) == true) {
				isReady = true;
			}else {
				isReady = false;
			}
			
		} catch (SAXException | IOException | ParserConfigurationException e) {
			log.error(e.getLocalizedMessage());
			e.printStackTrace();
			
			isReady = false;
		}
		
		return isReady;
	}
	
	private static boolean isContractAwardNotice(String xmlFile) throws SAXException, IOException, ParserConfigurationException {
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		
	    Document doc = documentBuilderFactory.newDocumentBuilder().parse(new File(xmlFile));
	    
	    NodeList nlF03 = doc.getElementsByTagName("F03_2014");
	    NodeList nlF21 = doc.getElementsByTagName("F21_2014");
	    NodeList nlF22 = doc.getElementsByTagName("F22_2014");
	    NodeList nlF23 = doc.getElementsByTagName("F23_2014");
	    NodeList nlF25 = doc.getElementsByTagName("F25_2014");
	    	    
	    if(nlF03.getLength()>0 || nlF25.getLength()>0 || nlF22.getLength()>0 || nlF23.getLength()>0 || nlF21.getLength()>0) {
	    	return true;
	    }
	    
	    return false;
	}
}
