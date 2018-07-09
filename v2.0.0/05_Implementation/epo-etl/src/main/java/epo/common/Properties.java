package epo.common;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/*
 * Eases the extraction of the value of one or a set of properties.
 * Only gets one property, for the time being.
 * Does not creates new properties, for the time being. 
 * 
 * @Author: Enric Staromiejski <http://everis.com>
 * @Update: 20180630
 */

public class Properties {
	
	/*
	 * The absolute path to the location of the properties file.
	 * Defaults to /home/user/epo.properties.
	 */
	private static String propertiesFilePathName = System.getProperty("user.home") + "/" + "epo.properties";
	private static java.util.Properties epoProperties = null;
	private static InputStream input = null;
	
	
	public static void setPropertiesFilePathName(String filePathName) {
		propertiesFilePathName = filePathName;
	}
	
	public static String getPropertiesFilePathName() {
		return propertiesFilePathName;
	}
	public static String getProperty(String key) {
		
		/*
		 * The creation and loading of the properties file content is done only once, 
		 * the first time a property is requested. 
		 */
		if (input == null) {
			epoProperties = new java.util.Properties();
			try {
				input = new FileInputStream(propertiesFilePathName);
				epoProperties.load(input);
			} catch (IOException ex) {
				ex.printStackTrace();
			} finally {
				if (input != null) {
					try {
						input.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
		return epoProperties.getProperty(key).trim();
	}
}