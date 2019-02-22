package epo.ted.stats;

import java.util.Hashtable;

public class Subsystem extends Stat{
	
	private Hashtable<String, Release> releases = null;
	private Snapshot snapshot = null;
	private String schemaLocation = null;
	
	public Subsystem(String id) {
		super(id);
		releases = new Hashtable<String, Release>();
		snapshot = new Snapshot();
	}
	
	public Subsystem() {
		super();
		releases = new Hashtable<String, Release>();
		snapshot = new Snapshot();
	}
	
	public Hashtable<String, Release> getReleases(){
		return releases;
	}
	
	public Release getRelease(String id) throws NullPointerException {
		try{
			Release d = releases.get(id);
			return d;
		} catch (NullPointerException e){
			throw new NullPointerException();
		}
	}
	
	public Form getForm(String releaseId, String formId) throws NullPointerException {
		Form f = null;
		try {
			f = this.releases.get(releaseId).getForm(formId);
			return f;
		} catch( NullPointerException e) {
			throw new NullPointerException();
		}	
	}
	
	public void setSchemaLocation(String schemaLocation) {
		this.schemaLocation = schemaLocation;
	}
	
	public String getSchemaLocation() {
		return this.schemaLocation;
	}
	
	public Release putRelease(String releaseId) {
		if(!exists(releaseId))
			releases.put(releaseId, new Release(releaseId));
		return getRelease(releaseId);
	}
	
	public boolean exists(String releaseId) {
		return getRelease(releaseId) != null ? true : false;
	}
	
	public boolean exists(String releaseId, String formId) {
		return getForm(releaseId, formId) != null ? true : false;
	}
	
	/**
	 * Returns the data stored in the current Record. A Record identifies the latter XML instance processed.
	 * @return the current Record.
	 */
	public Snapshot getSnapshot() {
		return snapshot;
	}
}
