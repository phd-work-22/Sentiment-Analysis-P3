/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SentimentAnalysis;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author tien rahayu t
 * These codes handle splitting paragraphs and normalising sentences.
 * The splitting step is as follow:
 *     1. Reading message's body from database called 'master_gentoo' by retrieving its message_id and message_body.
 *     2. Put the content into one variable called 'kommen' and subsequently reading one line at a time. While reading the line, the codes
 *        will check whether the line contains 'http', '<', 'on', '_' and other symbols founded at the first character of the line. 
 *        If the codes found the symbols, the line is ignored; otherwise, the line is kept in the variable 'komen'.
 *        If the number of 'komen' is less than 4, the komen is skipped. This is to check whether the line contain only names, 'best regards', 'regards'.
 */
public class NormalisedGentooMListsReport {
        public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException{
            Class.forName("com.mysql.cj.jdbc.Driver");
            File normFiles = new File( "/workdir/files/gentoo_mlists_normalised_koment.txt");
            PrintWriter printWriter = new PrintWriter(normFiles);
            
            try (Connection con = DriverManager.getConnection(  
                    "jdbc:mysql://localhost:3306/mlstats_gentoo","admin","Admin@123")) {
                
                Statement stmt=con.createStatement();
                ResultSet rs=stmt.executeQuery(
                        "select message_id, message_body from master_gentoo");   
                String kommen, kommen_id, komen; 

                /* Read all the comments from the database
                * Each line of the text are normalised
                * We skip all comments containing http, reply message, and sign
                * of the messagess' authors.
                */
                //check each sentence if it contains http, reply message, ignore it
                int i=1;
                while (rs.next()) {
                    kommen = "";
                    kommen_id = "";
                    komen = "";
                    //get the id of the message 
                    kommen = kommen + rs.getString("message_body");
                    komen = komen + splitIntoOneLine(kommen);
                    //System.out.println(komen);
                    kommen_id = kommen_id + rs.getString("message_id");
                    //if ( isNonvalidMessage(komen) ) continue;
                    if (countWords(komen) < 4 && matchingWords(komen))
                        continue;  

                    Pattern re = Pattern.compile
                        ("[^.!?\\s][^.!?]*(?:[.!?](?!['\"]?\\s|$)(?!\\\\d[.])[^.!?]*)*[.!?]?['\"]?(?=\\s|$)", Pattern.MULTILINE | Pattern.COMMENTS);
                        //("[^.!?\\d\\s][^.!?]*(?:[.!?](?!['\"]?\\s|$)(?!\\d[.])[^.!?]*)*[.!?]?['\"]?(?=\\s|$), Pattern.MULTILINE | Pattern.COMMENTS);

           
                    Matcher reMatcher = re.matcher(komen);
                    while (reMatcher.find()) {
                        //System.out.println(reMatcher.group());
                        //System.out.println(kommen_id);
                        printWriter.println
                            (kommen_id+"\t"+(i)+"\t"+reMatcher.group());

                    }
                    System.out.println("id: "+i);
                    //if (i == 10) break;
                    i++;
                    
                }   
                con.close();
                printWriter.close();
            }                   
    }
    
    public static boolean isNonvalidMessage(String comments) {       
        return comments.length() == 0 ||  comments.charAt(0) == '>' ||
           comments.charAt(0) == '-' || comments.charAt(0) == '_' || 
           comments.charAt(0) == '[' || comments.charAt(0) == '|' ||
           comments.charAt(0) == '$' || comments.charAt(0) == '#' || 
           comments.startsWith("http") || comments.endsWith("wrote:") ||
           comments.startsWith("On ") || comments.charAt(0) == '|' ||
           comments.toLowerCase().startsWith("am ") || 
           comments.toLowerCase().startsWith("pm ") ||    
           comments.contains("wrote");            
    }
    
    public static int countWords(String sentence) {
        int count=0;
        
        StringTokenizer st = new StringTokenizer(sentence);  
        while (st.hasMoreTokens()) {  
            st.nextToken();
            count++ ;
        }
        return count;
    }
    
    public static boolean matchingWords(String string) {
        Pattern re = Pattern.compile("[^\\.?]$", Pattern.MULTILINE | Pattern.COMMENTS);                
        Matcher reMatcher = re.matcher(string);
        return reMatcher.find();
    }
    
    public static String splitIntoOneLine(String comments) {
        String oneLine = "", bufferString; 
        StringTokenizer st = new StringTokenizer(comments, "\n");
        while (st.hasMoreTokens()) {
            bufferString = "";
            bufferString = bufferString + st.nextToken();
            if (isNonvalidMessage(bufferString)) 
                continue;
            else oneLine = oneLine + " " + bufferString;
        }
        //System.out.println(oneLine);
        return oneLine;
    }
    
}
