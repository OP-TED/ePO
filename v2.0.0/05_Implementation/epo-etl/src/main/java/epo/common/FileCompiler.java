package epo.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


/**
 * Calculates the number of files and directories inside a given directory. 
 * All the action is done in the concstructor.
 * @author Enric Staromiejski <http://everis.com>
 *
 */
public class FileCompiler {
	
	//private static Logger log = LogManager.getLogger(FileCompiler.class);	
	private File dir = null;
	private long fileCount = 0, dirCount = 0;
	private List<File> shortList = null;
	private File inputDir;
	private String outputDir;
	private boolean moveFile;
	
	public FileCompiler(String Directory) {
		this.dir = new File(Directory);
		this.count(dir);
	}
	/**
	 * 1) Takes a file containing a short list of file names;
	 * 2) Given an input directory with directories and long lists of files:
	 * 2.1) if the file in the short list is found in the input directory
	 * 2.1.a) it is moved (flag operation move=true) into the output directory, or
	 * 2.1.b) it is copied (flag operation move=false) into the output directory.
	 * @param fileList (filePathName containing the short list of files to move/copy)
	 * @param move (true==move or false==copy)
	 * @param inputDir (Directory where the long list of files is located, recursive reading)
	 * @param outputDir (Directory where the matched files are to be moved or copied).
	 * @return (returns the number of files moved or copied;
	 */
	public FileCompiler(String shortList, boolean move, String inputDir, String outputDir) {
		
		this.shortList = new ArrayList<File>();
		this.inputDir = new File(inputDir);
		this.outputDir = outputDir;
		this.moveFile = move;
		
		BufferedReader b = null;
		
		try {

            File f = new File(shortList);

            b = new BufferedReader(new FileReader(f));
            String readLine = "";

            while ((readLine = b.readLine()) != null) {
                this.shortList.add(new File(readLine));
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        	try{
                b.close();
                }catch (IOException e) {
                	e.printStackTrace();
                }
        }
	}
	
	public void move() {
		move(this.inputDir);
		//log.info(String.format("Total files read: %d\nTotal files moved/copied: %d", this.fileCount, this.shortList.size()));
		System.out.print(String.format("Total files read: %d\nTotal files moved/copied: %d", this.fileCount, this.shortList.size()));
	}
	
	public void move(File f) {
		if(f.isDirectory()) {
			File[] files = f.listFiles();
			for(int i = 0; i < files.length; i++) {
				if(files[i].isDirectory()) {
					++this.dirCount;
					this.move(files[i]);
				}else {
					Iterator<File> it = this.shortList.iterator();
					while (it.hasNext()) {
						String originalInLongListFile = files[i].getName(); 
						String originalInShortListFile = it.next().getName();
						//log.info("Comparing " + originalInLongListFile + " to " + originalInShortListFile);
						System.out.println("Comparing " + originalInLongListFile + " to " + originalInShortListFile);
						if (originalInLongListFile.equalsIgnoreCase(originalInShortListFile)) {
							Path source = files[i].toPath();
							Path target = new File(this.outputDir + "/" + files[i].getName()).toPath();
							try {
								if(this.moveFile)
									Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);
								else
									Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
							}catch(IOException e) {
								e.printStackTrace();
							}
						}	
					}
					++this.fileCount;
				}
			} 
		}
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
