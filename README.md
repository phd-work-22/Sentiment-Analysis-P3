# Title: Charaterizing developer sentiment in software components: a case study of Gentoo

Following is the steps of conducting our work based on the paper titled: Charaterizing developer sentiment in software components.

1. Extracting Mailing Lists and Commits data
   
1.1. Extracting Mailing Lists of Gentoo.
The mailing list retrieved from the archives of the Gentoo mailing lists shared in the following link: https://archives.gentoo.org/gentoo-dev/
The retrieved archives of the mailing list were kept in files.

1.2. Extracting Gentoo (Bugzilla) Commits data
The bugzilla report containing commits data retrieved from the repository in the following links: https://gitweb.gentoo.org/repo/gentoo/historical.git/; https://github.com/gentoo/gentoo.git
The retrieved archives of the commits were kept in files.

All of the files were converted into databases for further analysis.

2. Preprocessing the data

2.1 Normalisation of mailing list data
In this phase, we cleaned up the content of the message body. We removed lines prefixed by the character '\textgreater’, URLs, name(s) or signatures, greetings (i.e. "Kind Regards", and "Best Regards"). In addition, we removed lines containing code syntax and/or HTML/XML tags. 
 
2.2 Preprocessing component filepath
In this phase, we shortened the name of the component file path for each commit to extract 'head path' and 'path grain'

3. Identifying sentiment in the mailing list
We employed Sentistrength-SE to label each sentence of each message in the mailing list. The available SentiStrength can be found via this link: https://drive.google.com/drive/folders/1fyiqgrh_mP28uZJNIzAoMsAX3DWMa3RO

5. Aggregating, linking, and visualising data for analysis
4.1. Aggregating datasets of mailing data and commits
   We aggregated the number of positive and negative scores of all messages by year.
   We aggregated the number of commits done by each developers by time(month, year), author.

4.2 Linking and visualising data

All datasets are available by request.




