package epo.common;

import java.io.File;

/**
 * Calculates the number of files and directories inside a given directory. 
 * All the action is done in the concstructor.
 * @author Enric Staromiejski <http://everis.com>
 *
 */
public class FileCounter {
	
	private File dir = null;
	private long fileCount = 0, dirCount = 0;
	
	public FileCounter(String Directory) {
		this.dir = new File(Directory);
		this.count(dir);
	}
	private void count(File f) {
		if(f.isDirectory()) {
			File[] files = f.listFiles();
			for(int i = 0; i < files.length; i++) {
				if(files[i].isDirectory()) {
					++this.dirCount;
					this.count(files[i]);
				}else ++this.fileCount;
			} 
		} 	
	}
	/**
	 * Given an initial directory it calculates recursively the number of files, not directories, that 
	 * @param filePathName
	 * @return
	 */
	public long FileCount() {
		return fileCount;
	}
	
	public long DirectoryCount() {
		return dirCount;
	}

}
