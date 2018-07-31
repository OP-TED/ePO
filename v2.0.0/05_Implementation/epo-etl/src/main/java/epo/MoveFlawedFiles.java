package epo;

import epo.common.FileCompiler;

public class MoveFlawedFiles {
	
	public static void main(String[] args){
		
		String shortList = "/TED-Resources/DIRTY_SHORTLIST_APRIL_2018.txt";
		boolean move = false;
		String inputDir = "/TED-Resources";
		String outputDir = "/TED-OUTPUT";
		
		FileCompiler fc = new FileCompiler(shortList, move, inputDir, outputDir);
		fc.move();
	}

}
