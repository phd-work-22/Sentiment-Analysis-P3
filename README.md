# Title: Charaterising developer sentiment in software components: a case study of Gentoo

Following is the steps of conducting our work based on the paper titled: Charaterizing developer sentiment in software components.

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
   
   4.1. Aggregating datasets of mailing data and commits
   We aggregated the number of positive and negative scores of all messages by year.
   We aggregated the number of commits done by each developers by time(month, year), author.
   All the aggregations were done by using SQL.

   4.2 Linking and visualising data
   
   Any neccessary linkage between two datasets (mailing list and commits) for further analysis were done in SQL and R.
   All visualization in the study was done in R.

6. Manipulating tables to answer Research Questions
   
   5.1. RQ1 -- The extent of negative and positive emotions in the written communication in Gentoo, we aggregated the number of positive and negative scores labelled by the Sentistrength-
   SE throughout the period (between 2001 and 2023).

   Figure 1. (Total number of messages containing positive sentences and messages containing negative messages.
   Source code: 'fig_histograms_of_all_messages_and_sentiment.R'.

   Figure 2. Boxplots of the top 10 of active developers, DWNs, DWPs, regarding a relative numbers of commits done and of positive and negative sentences written.
   Source code: boxplots-negpos-4plots.R

   5.2. RQ2 -- The extent of negative and positive communication in Gentoo components
   Figure 3. Heatmaps of number negative and positive messages containing negative/positive sentences by grains with standard normalisasation (z-score) applied yearly.
   Source code: hmaps-sentiments-grains-standard-yearly.R

   Figure 4. Heatmaps of number negative and positive messages containing negative/positive sentences by paths with standard normalisation (z-score) applied yearly.
   Source code: hmaps-sentiment-standardnorm.R

   5.3. RQ3 -- The impact of emotion on the Gentoo's developers activity
   We calculated the inter-qurtile values (Q1 an Q3) of the z-scores of the differences between DWPs and DWNs and also the differences between positive and negative messages across
   the Gentoo evolution in each grain and path.
   Source codes: median_values_grains_norm_allyears.R and median_values_paths_norm_allyears.R.

   Figure 5. Bar graph of the number of commits of top ten negative paths and top ten positive paths.
   Source code: histogram of sentiment paths-commits.R.

All datasets are available by request.




