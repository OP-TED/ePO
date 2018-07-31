package epo.ted.stats;

public class Snapshot {

	String 	subsystem = null, release = null, form = null;
	
	public Snapshot() {	
	}
	public String getSubsystemId() {return this.subsystem;}
	public String getReleaseId() {return this.release;}
	public String getFormId() {return this.form;}
	public void setSubsystemId(String id) {this.subsystem = id;}
	public void setReleaseID(String id) {this.release = id;}
	public void setFormId(String id) {this.form = id;}
}
