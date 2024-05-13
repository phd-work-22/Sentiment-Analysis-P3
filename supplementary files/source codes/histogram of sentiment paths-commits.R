library(reshape2)
library(tidyr)
library(ggplot2)
library(stringr)
library(dplyr)
library(ggpubr)
library(scales)

setwd("/Volumes/Data/PhD/Gentoo/workdir/tables")
data <- read.csv("data-all-sentiments-commits2.csv",TRUE,';')
s_data <- 
  subset(data, select = c('path', 'year', 'n_neg_messages', 'n_pos_messages'))

data_all <- na.omit(s_data)
data_all$diff <- data_all$n_pos_messages - data_all$n_neg_messages
standard_normal<-function(x) {
  (x-mean(x))/sd(x)
}

data_all2 <- data_all %>% group_by(year) %>%
  mutate(norm = standard_normal(diff))

data_all2 <- na.omit(data_all2)
agg_diff <- data_all2 %>% group_by(path) %>%
  summarise(sum_norm = sum(norm))

m_data_all2 <- merge(data_all2, agg_diff, by=c('path'))

ordered_data <- m_data_all2 %>% arrange(sum_norm)

ordered_data$path <- factor(ordered_data$path, 
                            levels = unique(ordered_data$path))

list_all_paths <- 
  unique(subset(ordered_data, select = c('path','sum_norm')))

top_10_negs_paths <- list_all_paths[1:10,]
list_all_paths <- list_all_paths[order(-list_all_paths$sum_norm),]
top_10_pos_paths <- list_all_paths[1:10,]

data_commits <- subset(data, select = c('path', 'year','n_commits'))
top_ten_pos <- merge(top_10_pos_paths, data_commits, by='path')

m_data_top10_negs <- merge(top_10_negs_paths, data_commits, by='path')
m_data_top10_negs <- subset(m_data_top10_negs, select=c('year', 'n_commits'))
m_data_top10_negs <- m_data_top10_negs %>% group_by(year) %>%
                        summarise(negative_paths = sum(n_commits))

m_data_top10_pos <- merge(top_10_pos_paths, data_commits, by = 'path')
m_data_top10_pos <- subset(m_data_top10_pos, select = c('year', 'n_commits'))
m_data_top10_pos <- m_data_top10_pos %>% group_by(year) %>%
                      summarise(positive_paths = sum(n_commits))
# Create data frame
data <- merge(m_data_top10_negs, m_data_top10_pos, 
              by='year', all=TRUE)

# Reshape data for ggplot
data_melted <- melt(data, id.vars = "year", variable.name = "group")
mycolors <- c("#b2182b","#2166ac")

ggplot(data_melted, aes(x = year, y = value, fill = group)) +
  scale_x_continuous(limits = c(2000.5, 2023.5), expand=c(0,0), 
                     breaks = ordered_data$year) +
  scale_y_continuous(limits = c(-1.5, 12500), expand=c(0,0),
                     labels = scales::comma) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "",
       y = "# of commits")+
  theme( axis.ticks.y = element_blank(),
         axis.ticks.x = element_blank(),
         axis.text.x = element_text(angle=45,vjust = 0.5, hjust=0.3,size=8),
         legend.position = "bottom",
         legend.margin  = margin(-5,0,0,0),
         legend.title = element_blank()) +
  scale_fill_discrete(labels = c("negative paths", "positive paths")) +
  scale_fill_manual(values=mycolors) 

