package epo.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import org.apache.commons.io.FileUtils;
import org.apache.http.HttpHost;
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
	private long totalCompiled, current;
	
		Repository repo = null;
		RemoteRepositoryManager  manager = null;
		RepositoryConnection con = null;
		epo.common.Properties p = new epo.common.Properties();
		String serverUrl 		= null,
			   user 			= null,
			   password 		= null,
			   proxyURL 		= null,
			   repositoryName 	= null;
		
		int    proxyPort;
		
		public KBManagement() {
		}
		
		/** 
		 * Used for statistic purposes;
		 * @param compiledFiles
		 */
		public void setTotalFilesToInsert(long compiledFiles) {
			totalCompiled = compiledFiles;
		}
		
		public void initGraphDBRepository() {
		logger.info("Init GraphDB connection.");

		try {
			// Compulsory properties
			serverUrl 		= Properties.getProperty("GRAPH_STORE_URL");
			repositoryName	= Properties.getProperty("GRAPH_STORE_REPOSITORY");
		}catch(NullPointerException e){
			logger.error("Impossible to connect to the Graph Store because at least one compulsory property is not present. Please check the values of GRAPH_STORE_URL and GRAPH_STORE_REPOSITORY in your epo.properties configuration file");
		}
		
		try {
			// Optional properties
			user 			= Properties.getProperty("GRAPH_STORE_USER");
			password 		= Properties.getProperty("GRAPH_STORE_PASSWORD");
			proxyURL 		= Properties.getProperty("PROXY_URL");
			
			String sProxyPort = Properties.getProperty("PROXY_PORT");
			if (sProxyPort != null)
				proxyPort 		= Integer.parseInt(sProxyPort);
		} catch (NullPointerException e) {
			//Do nothing, they're optional!
		}
			
		try {
			
			manager = new RemoteRepositoryManager(serverUrl);
			 
			if (user != null && password != null) manager.setUsernameAndPassword(user, password);
			
			manager.initialize();
			
			// proxy settings
			if (proxyURL != null) {
				HttpHost proxy = new HttpHost(proxyURL, proxyPort,"http");
				DefaultHttpClient client = new DefaultHttpClient();			
				client.getParams().setParameter(ConnRoutePNames.DEFAULT_PROXY, proxy);
				manager.setHttpClient(client);
			}
		
			repo = manager.getRepository(repositoryName);
			con = repo.getConnection();
		
		} catch(RepositoryException | NullPointerException e) {
			
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
	public void readAndExecuteSPARQL(File inputFile) throws Exception {	
		
		String query = "";
		
		logger.info("Starting query file [" + ++current + "/" + totalCompiled + "]:" + inputFile.getName());
		
		try {
			//Transforms the content of the file into String
			query = FileUtils.readFileToString(inputFile, "UTF-8");

			//Executes the query
			
		    Update update = con.prepareUpdate(QueryLanguage.SPARQL, query);
		    update.execute();
		
			
		    
		} catch (IOException | RepositoryException | MalformedQueryException | HTTPUpdateExecutionException e ) {
			logger.error(e.getMessage() + "The file causing the problem is: " + inputFile.getName());
			e.printStackTrace();
			throw new Exception();
		}  
	}	
}
