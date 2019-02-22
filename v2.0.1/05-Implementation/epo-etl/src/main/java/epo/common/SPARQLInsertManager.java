package epo.common;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Big files, of more than 1.5 MB containing many SPARQL Insert queries, stall the GraphDB Engine. 
 * This class specialises in isolating each Insert query in independent queries and executes them individually, instead of in one
 * single transactional block. 
 */
public class SPARQLInsertManager {

	private String namespaces = null;
	private List<String> queryPool = null;
	
	public SPARQLInsertManager() {		
	}
	
	private boolean lineIsInsert(String line) {
		return line.toUpperCase().contains("INSERT");
		
	}
	public String getNameSpaces() {
		return this.namespaces;
	}
	public List<String> getQueryPool() {
		return this.queryPool;
	}
	private String isolateNamespaces(BufferedReader br) {
		
		String line = null;
		this.namespaces = "";
		
		try {
			while(((line = br.readLine()) != null) && !lineIsInsert(line)) {
				this.namespaces += line.trim() +"\n";
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		// The last line read MUST contain an INSERT clause, otherwise the file is flawed.
		return line; 
	}
	/**
	 * Isolates in strings each SPARQL Insert Query and adds them to a dynamic List. 
	 * @param insertClause the first INSERT clause detected after reading the namespaces
	 * @return the list of queries, one query per element of the list.
	 */
	private List<String> getInsertBlocks(String insertClause, BufferedReader br){
		List<String> pool = new ArrayList<String>();
		String query = insertClause.trim();
		String line = null;
		try {
			while((line = br.readLine()) != null) {
				if(!lineIsInsert(line)) query += line.trim() + "\n";
				else { 
					// If line contains INSERT then isolate the previous query
					pool.add(this.namespaces + query);
					// start a new query object
					query = line + "\n";					
				}
			}
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}	
		
		return pool;	
	}
	
	public void loadFile(String inputFilePathName) {
		try (BufferedReader br = new BufferedReader(new FileReader(inputFilePathName))) {
			// the first line should returned after having read the namespaces MUST be an Insert clause.
			String insertClause = isolateNamespaces(br);
			queryPool = getInsertBlocks(insertClause, br);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
}
