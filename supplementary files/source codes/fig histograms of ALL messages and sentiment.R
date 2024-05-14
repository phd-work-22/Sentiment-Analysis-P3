library(dplyr)
library(ggplot2)
library(reshape2)
library(ggtext)
library(scales)

setwd("/Volumes/Data/PhD/Gentoo/workdir/tables")
messages_sent <- read.csv("#messages_yearly_2001_2023.csv",TRUE,";")

negative_sent <- read.csv("messages_containing_Negsentences-CLEANED.csv", TRUE, sep=";")
positive_sent <- read.csv("list_messages_containing_strongPosSentences_2024-CLEANED.csv", TRUE, sep=";")

messages_sent <- as.data.frame(messages_sent)
negative_sent <- as.data.frame(negative_sent)
positive_sent <- as.data.frame(positive_sent)

# assigning new names to the columns of the data frame of strong negative
# sentences(score <= 3) 

#sentences used written in the range of year spanning from 2001 and 2021
#15907 sentences
selected_columns <- subset(negative_sent,select = c('message_id','email','year', 'month'))
selected_columns_pos <- subset(positive_sent,select = c('message_id','email','year', 'month'))

# aggregating all negative messages sent by sender and sorted descending by
# number of negative messages
selected_columns <- unique(selected_columns, select = c('message_id'))
selected_columns_pos <- unique(selected_columns_pos, select = c('message_id'))
df_strong_messages <- selected_columns %>% count(year)
colnames(df_strong_messages) <- c('year', 'no_messages')

df_strong_pos_messages <- selected_columns_pos %>% count(year)
colnames(df_strong_pos_messages) <- c('year', 'no_messages')

## merging two dataframes 
all_df = merge(messages_sent, df_strong_messages, by = "year")
all_df <- merge(all_df, df_strong_pos_messages, by = "year")
colnames(all_df) <- c('year', 'total_messages', 'neg_messages', 'pos_messages')
all_df$non_strong_messages <- 
  (all_df$total_messages - all_df$neg_messages - all_df$pos_messages) 

data <- data.frame(all_df[,1], all_df[,3], all_df[,4], all_df[,5])
colnames(data) <- c('year', 'negativeMessages', 'positiveMessages', 
                    'neutralMessages')

data_reshape <- melt(data, id.vars = "year")
data_reshape <- 
  data_reshape[order(data_reshape$year, -rank(data_reshape$variable)),] %>%
  group_by(year)  %>%
  mutate(label_y = (value/sum(value)*100))

data_reshape <- data_reshape %>% filter(variable != 'neutralMessages')

mycolors <- c("#b2182b","#2166ac")

plot <- ggplot(data_reshape, aes(x = year, y = value, 
                         fill = variable)) +
  scale_x_continuous(breaks=data_reshape$year, 
                     limits = c(2000.5, 2023.5), expand=c(0,0)) +
  geom_col(position = position_stack(reverse=TRUE)) +
  #geom_bar(stat = "identity", position = "dodge") +
  # geom_text(aes(x=year, y=value, label = paste(round(label_y,digits=1),'%')),
  #           position = position_stack(reverse=TRUE,vjust = 0.7), 
  #           size = 3, color="white") +
  scale_y_continuous(breaks=pretty_breaks(5),  
                     limits = c(-1.5, 2200), expand=c(0,0), labels = scales::comma) +
  labs(x = "", y = "number of messages") +
  theme(axis.text.y = element_text(hjust = 1, vjust=0.5,size=10),
        axis.text.x = element_text(vjust = 0.5,size=9.5, angle=45),
        legend.position = "bottom",
        legend.margin  = margin(-5,0,0,0),
        legend.text = element_text(size=12),
        axis.title.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        axis.ticks.y = element_blank(),
        axis.ticks.x = element_blank(),
        panel.border = element_blank())+
  scale_fill_discrete(labels = c("negative messages", "neutral messages")) +
  scale_fill_manual(values=mycolors) 
plot
