package epo.ted.stats;

import java.util.Hashtable;

public class Release extends Stat{

		Hashtable<String, Form> forms = null;
		String version = null;
		
		public Release() {
			super();
			forms = new Hashtable<String, Form>();
		}
		public Release(String id) {
			super(id);
			forms = new Hashtable<String, Form>();
		}
		
		public Hashtable<String, Form> getForms(){
			return forms;
		}
		
		public Form getForm(String id) {
			return forms.get(id);
		}
		
		public Form putForm(String formId) {
			if(!exists(formId))
				this.forms.put(formId, new Form(formId));
			return getForm(formId);
		}
		
		public boolean exists(String FormId) {
			return getForm(FormId) != null ? true : false;
		}
		public void setVersion(String versionId) {
			version = versionId;
		}
		public String getVersion() {
			return version;
		}
		
		/*
		 * Creates as many Form objects as indicated in the input parameter n.   
		 *
		 * @param n the number of <b>empty</b> forms that you want to create identified as "F01" to "Fn". 
		 */
		
		public void populate(int n) {
			for(int i = 1; i <= n; i++ ) {
				String key = "F" + (i < 10 ? "0" + i : i);
				Form form = new Form(key);
				this.forms.put(key, form);
			}	
		}
		
}
