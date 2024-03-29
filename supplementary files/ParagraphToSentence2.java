
package paragraphtosentence;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParagraphToSentence2 {

    public static void main(String[] args) throws FileNotFoundException, IOException{

        // Read the files
        // File path is passed as parameter
        String[] params = new String [2];
        params[0] = "/home/p306654/Documents/SEfiles/sentistrength.sh";
        params[1] = "/home/p306654/Documents/SEfiles/gentoo_mlists_normalised_messages.txt";
        Runtime.getRuntime().exec(params);
        
        File file = new File (params[1]);
 
        // Creating an object of BufferedReader class
        BufferedReader br
            = new BufferedReader(new FileReader(file));
 
        // Declaring a string variable
        String comments;
       
        FileWriter fileWriter = new FileWriter
        ("/home/p306654/Documents/SEfiles/editedSample.txt");
        try (PrintWriter printWriter = new PrintWriter(fileWriter)) {
            int id=1;
            while ((comments = br.readLine()) != null) {

                Pattern re = Pattern.compile("[^.!?\\s][^.!?]*(?:[.!?](?!['\"]?\\s|$)[^.!?]*)*[.!?]?['\"]?(?=\\s|$)", 
                        Pattern.MULTILINE | Pattern.COMMENTS);
                
                Matcher reMatcher = re.matcher(comments);
                while (reMatcher.find()) {
                    //System.out.println(reMatcher.group());
                    printWriter.println(id+"\t"+reMatcher.group());
                }
                id++;
            }    
        }
        
    }
            
}  
    
