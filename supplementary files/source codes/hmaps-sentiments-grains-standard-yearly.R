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
s_data$path <- word(s_data$path, sep='-',1)

data_all <- na.omit(s_data)

agg_all_grains <- data_all %>% 
  group_by(path, year) %>%
  summarise(sum_neg_mess = sum(n_neg_messages), 
            sum_pos_mess = sum(n_pos_messages))

standard_normal<-function(x) {
  (x-mean(x))/sd(x)
}

agg_all_grains$diff = agg_all_grains$sum_pos_mess - agg_all_grains$sum_neg_mess

data_all2 <- agg_all_grains %>% group_by(year) %>%
  mutate(norm = standard_normal(diff))

agg_diff <- data_all2 %>% group_by(path) %>%
  summarise(sum_diff = sum(diff))

m_data_all2 <- merge(data_all2, agg_diff, by=c('path'))
ordered_data <- m_data_all2 %>% arrange(sum_diff)
ordered_data$path <- factor(ordered_data$path, 
                            levels = unique(ordered_data$path))

my_palette <- c('#67001f','#b2182b','#d6604d',
                         '#f4a582','#fddbc7','#f7f7f7',
                         '#d1e5f0','#92c5de','#4393c3',
                         '#2166ac','#053061')

colnames(ordered_data)[colnames(ordered_data) == "path"] <- "grain"
plot_signi <- ggplot(ordered_data, aes(x=year, y=grain, fill=norm), ) +
  geom_tile(color = "black") + 
  scale_fill_gradientn(colors = my_palette, 
                       limits= c(-3.3, 2)) + 
#                       breaks = c(-3,-2,-1,0,1,2,3,4)) +
  scale_x_continuous(limits = c(2000.5, 2023.5), expand=c(0,0), 
                     breaks = ordered_data$year)+
  coord_fixed() +
  theme(axis.text.y = element_text(hjust = 1, vjust=0.5, size = 10),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle=90,vjust = 0.5, hjust=1,size=13),
        legend.position = "top", legend.margin = margin(-3,0,0,-10),
        legend.text = element_text(size=7),
        legend.title = element_text(size=12, vjust=1),
        panel.background = element_rect(fill="white"),
        panel.grid.major = element_line(colour = "grey", size = 0.1))+
  labs(fill="z-score of the number of differences between positive and negative messages")
plot_signi + coord_flip()
