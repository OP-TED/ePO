package epo.ted.stats;

import java.util.Hashtable;
import java.util.Map;

public class StatMapStruct {

	// The following three tables are used for statistical purposes. See diagram TED-stats-vocabulary
	private Hashtable<String, Map<String, Map<String, int[]>>> subsystem = null;
	private Hashtable<String, Map<String, int[]>> release = null;
	private Hashtable<String, int[]> form = null;
	
	public StatMapStruct(){
		form = new Hashtable<String, int[]>();
		release = new Hashtable<String, Map<String, int[]>>();
		subsystem = new Hashtable<String, Map<String, Map<String, int[]>>>();
		
	}
	
	void prepareExample() {
		
		int []totals = {1, 2};
		form.put("F01", totals);
		release.put("R2.0.9.S01.E01", form);
		subsystem.put("TED_EXPORT", release);
		
	}
	void showExample(){
	
		System.out.println(subsystem.get("TED_EXPORT").get("R2.0.9.S01.E01").get("F01")[0]);
		
	}
}
