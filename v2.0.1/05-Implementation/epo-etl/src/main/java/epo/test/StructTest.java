package epo.test;

import java.util.Iterator;

import epo.ted.stats.Form;
import epo.ted.stats.Release;
import epo.ted.stats.StatCodes;
import epo.ted.stats.Subsystem;

public class StructTest {

	static int PROCESSED = 1, SKIPPED = 2;
	
	public static void main(String[] args) {

		Subsystem s = new Subsystem("TED_EXPORT");
		/* 
		 * Adds a Release object in the Subsystem Schema Type object "TED_EXPORT" and 
		 * fills the Release with 25 empty Forms, from F01 to F025
		 */
		s.putRelease("R2.0.9.S01.E01").populate(25);
		s.getRelease("R2.0.9.S01.E01").getForm("F01").inc(StatCodes.PROCESSED);
		s.getRelease("R2.0.9.S01.E01").getForm("F01").inc(StatCodes.PROCESSED);
		s.getRelease("R2.0.9.S01.E01").getForm("F01").inc(StatCodes.PROCESSED);
		s.getRelease("R2.0.9.S01.E01").getForm("F01").inc(StatCodes.SKIPPED);
		
		// This method returns a form in a specific Release or throws NoSuchFormExistsException if it does not exist. 
		try {
			
			System.out.println("FORM ID: " + s.getForm("R2.0.9.S01.E01", "F01").getId());
			
		}catch (NullPointerException e) {
			// Do Nothing
		}
		
		Iterator <String> it = s.getReleases().keySet().iterator();
		
		while (it.hasNext()) {
		
			Release d = s.getRelease(it.next());
			System.out.println("Release: " + d.getId());
			System.out.println("--------------------------------------------");
			
			int size = d.getForms().size();
			for (int i = 0; i < size; i++)
			{
				String fid = "F" + (i < 9 ? "0" + (i+1) : (i+1));
				Form f = d.getForm(fid);
				System.out.println("Form type: " + f.getId() + ", total processed: " + f.getProcessed() +", total skipped: " + f.getSkipped() + ", total read:" + f.getRead());
			}
	}
	}
}
