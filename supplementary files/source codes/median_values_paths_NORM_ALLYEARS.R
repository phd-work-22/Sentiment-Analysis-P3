setwd("/Volumes/Data/PhD/Gentoo/workdir/tables")
# This codes dealth with steps of finding out the median values of
# both sentiment polarities and DWNS/DWPS
# the normalised_data-new.csv used here are the file that has been
# analysed in particular on the relation built upon
# the date basis (year, month, day) from datasets of negative/positive sentences
# in the mailing lists and commits

df_devops <- read.csv("normalised_developers-by-paths.csv",TRUE,',')
df_devops <- subset(df_devops, select = c('path', 'year', 'variable', 'norm'))
df_dataSentences <- read.csv("normalised_data-new.csv",TRUE,',')
df_dataSentences <- subset(df_dataSentences, 
                           select = c('path', 'year', 'variable', 'norm'))

sdata_all_norm <- subset(df_dataSentences, between(year, 2019, 2023)) %>%
  filter(variable == 'n_negs')
median_negs <- aggregate(sdata_all_norm$norm,
                         by=list(sdata_all_norm$path),
                         FUN = median, na.rm = TRUE)
colnames(median_negs) <- c('path', 'median_normalised_n')
write.csv(median_negs, 
          "/Volumes/Data/PhD/Gentoo/CSV Files/median/2019-2023_Median_values_PATH.csv", 
          row.names=TRUE)
################################################################################
# calculating the median values of DWNS
#separete normalisation with min-max function BY YEAR 
sdata_all_norm_dwns <- subset(df_devops, between(year, 2019, 2023)) %>%
  filter(variable == 'n_dwns')
median_dwns <- aggregate(sdata_all_norm_dwns$norm,
                         by=list(sdata_all_norm_dwns$path),
                         FUN = median, na.rm = TRUE)
colnames(median_dwns) <- c('path', 'median_normalised_n')
write.csv(median_dwns, 
          "/Volumes/Data/PhD/Gentoo/CSV Files/median/2019-2023_Median_DWNS_values_PATH.csv", 
          row.names=TRUE)
################################################################################
#processing the positive datasets
################################################################################
sdata_all_norm_pos <- subset(df_dataSentences, between(year, 2019, 2023)) %>%
  filter(variable == 'no_pos')

median_pos <- aggregate(sdata_all_norm_pos$norm,
                        by=list(sdata_all_norm_pos$path),
                        FUN = median, na.rm = TRUE)
colnames(median_pos) <- c('path', 'median_normalised_n')
write.csv(median_pos, 
          "/Volumes/Data/PhD/Gentoo/CSV Files/median/2019-2023_Median_POSvalues_PATH.csv", 
          row.names=TRUE)
################################################################################
sdata_all_norm_dwps <- subset(df_devops, between(year, 2019, 2023)) %>%
  filter(variable == 'n_dwps')

median_dwps <- aggregate(sdata_all_norm_dwps$norm,
                         by=list(sdata_all_norm_dwps$path),
                         FUN = median, na.rm = TRUE)
colnames(median_dwps) <- c('path', 'median_normalised_n')
write.csv(median_dwps, 
          "/Volumes/Data/PhD/Gentoo/CSV Files/median/2019-2023_Median_DWPS_values_PATH.csv", 
          row.names=TRUE)



