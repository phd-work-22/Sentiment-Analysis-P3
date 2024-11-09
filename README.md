# Title: Investigating Developer Sentiments in Software Components: An Exploratory Case Study of Gentoo

Following is the steps of conducting our work based on the paper titled: Investigating Developer Sentiments in Software Components: An Exploratory Case Study of Gentoo

1. Extracting Mailing Lists and Commits data
   
   1.1. Extracting Mailing Lists of Gentoo.
   
   The mailing list retrieved from the archives of the Gentoo mailing lists shared in the following link: https://archives.gentoo.org/gentoo-dev/
   The retrieved archives of the mailing list were kept in files.
   Source code: GentooMonthlyMessageScrapper.py
   Output of the code is a list of *.csv files containing Gentoo's email monthly.
   We merge all of the files into a file called 'gentoo_mlists_all.csv' with a source code named: merging_all_data.R. 

   1.2. Extracting Gentoo Commits data
   
   The commits data were retrieved from the repository in the following links: https://gitweb.gentoo.org/repo/gentoo/historical.git/;
   https://github.com/gentoo/gentoo.git
   The retrieved archives of the commits were kept in files.
   Source code: GentooCommitLoading.py
   
   All of the files were converted into tables for further analysis.

3. Preprocessing the data

   2.1 Cleaning the emails
   In this phase, we cleaned up the content of the message body. We removed lines prefixed by the character '\textgreater’, URLs, name(s) or signatures, greetings (i.e. "Kind
   Regards", and "Best Regards"). In addition, we removed lines containing code syntax and/or HTML/XML tags.
   Source code: NormalisedGentooMListsReport.java. The output of the file is gentoo_mlists_normalised_koment.txt.
 

4. Identifying sentiment in the mailing list
   
   Using the java-based tool Sentistrength-SE, we did the labelling or giving scores to each sentence. Source code: ExecuteSentistrengthSE.java; output: results of sentimen
   analysis gentoo mlists.txt. File included is sentistrength.sh.
   In order to giving the scores to each sentence, we have to compile and run the ExecuteSentistrengthSE.java together with file 'gentoo_mlists_normalised_komen.txt' as its input      and its ouput as 'results of sentimen analysis gentoo mlists.txt'

5. Aggregating, linking, and visualising data for analysis
   
   5.1. RQ1
   - We aggregated the number of positive and negative scores of all messages by year.
   - We aggregated the number of postive and negative sentences written by DWNs, DWPs, and Active developers.
        - We calculated the proportion between posisitve or negative sentences and the total messages written and normalized the proportion with a log scale.
   - We aggregated the number of commits done and the total contributions (in months) made by each developer.
       - We calculated the proportion between the number of the commits done the contributions and normalized with a log scale.
   - We visualized the aggregations into a histogram (Figure 4) and boxplots (Figure 5)
  
   5.2 RQ2
   - We linked the sentiment and commit dataset by timestamp (year, month, and day)
     - Using the linked data, we aggregated the number of negative and positive messages in each path(category) yearly
     - Similarly, we aggregated the number of sentiments messages at the category/path grain level.
     - We calculated the substraction between the number of positive and negative messages in each path/category and path/category grain throughout the years to determine how high
       the sentiment is. We normalized the results of the substraction and visualized the normalized results into heatmaps (Figure 6 and 7)

   5.3 RQ3
   - We linked DWNs and DWPs dataset with commit dataset by name, year, month, and day.
     - We aggregated the number of DWNs and DWPs working on each path/category and path/category grain.
       - We calculated the substraction between the number of DWNs and DWPs in each path/category and path/category grain throughout the years. We normalized all those the substraction values in each path/category and grain with z-score.
   - Similarly, regarding the distribution of the sentiments on the paths and path grains, we conducted the linking method as we did in the answer to RQ2.
   - We calculated the media values of all normalized values distributed in paths and grains between 2001 and 2023.
     - We employed those median values and applied descriptive statistics (e.g. Q1 and Q3) to determine three categories (High, Medium, and Low). Please see our paper for more details.
  - We visualized the distribution of the affected grains (Figure 8) and paths (Figure 9)

  - We sampled top ten positive and negative paths and used the number of commits done in each path/category.
  - We visualized the distribution of the commits in each path.

   The aggregations and visualization were done in SQL and R.
   All datasets and source codes are available by request.




