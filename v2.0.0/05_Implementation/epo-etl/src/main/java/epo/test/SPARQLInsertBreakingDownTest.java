package epo.test;

import java.util.Iterator;

import epo.common.SPARQLInsertManager;

public class SPARQLInsertBreakingDownTest {

	public static void main(String[] args) {
		
		SPARQLInsertManager im = new SPARQLInsertManager();
		im.loadFile("/TED-OUTPUT/090344_2018.xml_output.txt");
		System.out.print(im.getNameSpaces() + "\n\n");
		
		Iterator<String> it = im.getQueryPool().iterator();
		
		while(it.hasNext()) {
			System.out.println(it.next() + "\n\n");
		}
	}

}
