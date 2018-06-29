package epo.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.commons.io.FileUtils;
import org.apache.http.HttpHost;
import org.apache.http.client.HttpClient;
import org.apache.http.conn.params.ConnRoutePNames;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.eclipse.rdf4j.query.MalformedQueryException;
import org.eclipse.rdf4j.query.QueryLanguage;
import org.eclipse.rdf4j.query.Update;
import org.eclipse.rdf4j.repository.Repository;
import org.eclipse.rdf4j.repository.RepositoryConnection;
import org.eclipse.rdf4j.repository.RepositoryException;
import org.eclipse.rdf4j.repository.http.HTTPUpdateExecutionException;
import org.eclipse.rdf4j.repository.manager.RemoteRepositoryManager;


/**
 * Management of the Knowledge Base (GraphDB)
 * @author mfontsan
 *
 */
public class KBManagement {
	private static Logger logger = LogManager.getLogger(KBManagement.class);
	
		Repository repo = null;
		RemoteRepositoryManager  manager = null;
		RepositoryConnection con = null;
		String serverUrl 	= null,
			   user 		= null,
			   password 	= null,
			   proxyURL 	= null; 
		int    proxyPort;
		
		public void initGraphDBRepository() {
		logger.info("Init GraphDB connection.");

		String currentUsersHomeDir = System.getProperty("user.home");
		String epoProperties = currentUsersHomeDir + "\\epo.properties";
		
		Properties p = new Properties();
		InputStream input = null;
		
		try {
			
			input = new FileInputStream(epoProperties);
			p.load(input);
			serverUrl 	= p.getProperty("GRAPH_STORE_URL");
			user 		= p.getProperty("GRAPH_STORE_USER");
			password 	= p.getProperty("GRAPH_STORE_PASSWORD");
			proxyURL 	= p.getProperty("PROXY_URL");
			proxyPort 	= Integer.parseInt(p.getProperty("PROXY_PORT"));
			
			
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
		
		//String serverUrl = "http://localhost:7200";
		try {
			
			manager = new RemoteRepositoryManager(serverUrl);
			manager.setUsernameAndPassword(user, password);
			manager.initialize();
			
			// proxy settings
			
			HttpHost proxy = new HttpHost(proxyURL, proxyPort,"http");
			
			DefaultHttpClient client = new DefaultHttpClient();			
			client.getParams().setParameter(ConnRoutePNames.DEFAULT_PROXY, proxy);
			
			manager.setHttpClient(client);
			
			repo = manager.getRepository("ePO");
			con = repo.getConnection();
		
		} catch(RepositoryException e) {
			
			System.out.println(e.getLocalizedMessage());
		}
			

		logger.info("Current initialization status of the repository:" + repo.isInitialized());
	}
	
	/**
	 * Shutdown repository and manager
	 */
	public void shutDownGraphDB() {
		
		try {
			con.close();
			repo.shutDown();
			manager.shutDown();
		}catch (NullPointerException e) {
			System.out.println(e.getMessage());
		}
				
	}
	
	/**
	 * Execution of the SPARQL query send in the input file
	 * @param File - input file that contains the SPARQL query
	 */
	public void readAndExecuteSPARQL(File inputFile) {	
		
		
		String query = "";
		
		try {
			//Transforms the content of the file into String
			query = FileUtils.readFileToString(inputFile, "UTF-8");

			//Executes the query
			
		    Update update = con.prepareUpdate(QueryLanguage.SPARQL, query);
		    update.execute();
			
		    
		} catch (IOException | RepositoryException | MalformedQueryException | HTTPUpdateExecutionException e ) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	      
	}	
}
