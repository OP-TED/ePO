package epo.stax;

import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

public class Parser {

	protected XMLStreamReader reader = null;
	protected String elementName = null;
	protected String rootElementName = null;
	protected String defaultSpaceName = null;
	protected String schemaLocation = null;
	protected String schemaVersion = null;
	
	/**
	 * Constructor -> Beware that the constructor performs a series of operations to get the maximum information 
	 * needed about the root element. This entails that the next lookup will be executed on subsequent elements, and
	 * the root will have been skipped.
	 * 
	 * @param reader -> external classes methods wanting to parse an XML instance have already created a Factory and a reader.
	 */
	public Parser(XMLStreamReader reader) throws XMLReaderNullException {
		if((this.reader = reader) == null) throw new XMLReaderNullException();
		getRootElementData();
	}
	
	private void getRootElementData() {
		this.LookUpElement(null);
		this.rootElementName = this.reader.getLocalName();
		this.defaultSpaceName = this.reader.getNamespaceURI();
		this.schemaLocation = this.reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance", "schemaLocation");
		this.schemaVersion = this.getAttributeValue("VERSION");
		this.schemaVersion = (this.schemaVersion == null ? this.schemaLocation : this.schemaVersion); 
		
	}
	
	public String getRootElementName() {
		return this.rootElementName;
	}
	public String getDefaultNamespace() {
		return this.defaultSpaceName;
	}
	public String getSchemaVersion() {
		return this.schemaVersion;
	}
	public boolean LookUpAttribute(String attributeName) {
		try {
			while (reader.hasNext()) {
				int eventType = reader.next();
	            switch (eventType) {
	                case XMLStreamReader.START_ELEMENT:
	                		for (int i = 0; i < reader.getAttributeCount(); i++) 
	                			if(reader.getAttributeLocalName(i).equalsIgnoreCase(attributeName))
									return true;
	            }
	        }
		} catch (XMLStreamException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean LookUpElement(String elementName) {
		
		try {
			while (reader.hasNext()) {
				int eventType = reader.next();
	            switch (eventType) {
	                case XMLStreamReader.START_ELEMENT:
	                	if(elementName == null) return true;
	                	else if (elementName.equalsIgnoreCase(reader.getLocalName())) return true;        
	            }
	        }
		} catch (XMLStreamException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * Looks for an attribute named "FORM".
	 * @return The value of the attribute or UNKNOWN if the attribute is not found.
	 */
	public String getFormType() {
		// Skips all elements until the attribute "FORM" is found.
			if(this.LookUpAttribute("FORM"))
				return reader.getAttributeValue(null, "FORM");
			else 
				return "UNKNOWN";
	}
	public String getAttributeValue(String attributeName) throws NullPointerException {
		return reader.getAttributeValue(null, attributeName);
	}
}
