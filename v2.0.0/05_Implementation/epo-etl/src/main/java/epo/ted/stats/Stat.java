package epo.ted.stats;

public class Stat {

	private long totalCompiled, totalProcessed, totalSkipped, totalRead;
	
	private String id = null;
	
	public Stat() {
	}
	
	public Stat(String id) {
		this.id = id;
	}
	
	public String getId(){
		return this.id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * Counters incrementing. Different descendants use this differently, see how Subsystem and Form use it.
	 * @param code  -> indicate which counter to increment; Observe that the totalRead is incremented always.
	 *				-> expected values are PROCESSED = 1, SKIPPED =2, any other value =  READ.
	 */
	public void inc(StatCodes code) {
		++totalRead;
		switch(code) {
		case PROCESSED: ++totalProcessed;break;
		case SKIPPED: ++totalSkipped; break;
		case READ: break;
		default:
			break;
		}
	}
	/*
	 * Total number of forms on one specific type (identifier) that have been transformed;
	 */
	public long getProcessed() {
		return totalProcessed;
	}
	public void setProcessed(long processed) {
		totalProcessed = processed;
	}
	/*
	 * Total number of forms on one specific type (identifier) that have been skipped;
	 */	
	public long getSkipped() {
		return totalSkipped;
	}
	public void setSkipped(long skipped) {
		totalSkipped = skipped;
	}
	
	/*
	 * Total number of forms on one specific type (identifier) that have been read (transformed + skipped);
	 */
	public long getRead() {
		return totalRead;
	}
	public void setRead(long read) {
		totalRead = read;
	}
	public void setCompiled(long totalCompiled) {
		this.totalCompiled = totalCompiled;
	}
	public long getCompiled() {
		return totalCompiled;
	}
}
