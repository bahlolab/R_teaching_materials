
#TIDYR

#Week 3 factors_tidyr

#Learning outcomes:
  #understand factors: groupings / labels for subsets of your data
  #join data based on common keys
  #reshape data using gather() and spread()
  #separate/unite data by column



##########################

##########################

library(tidyverse)

#FACTORs

#plot age by fare, facet by class
tt %>% ggplot(aes(y=Fare,x=Age)) + geom_point() +
  facet_wrap( ~ Pclass, scales="free")

#factors: turn character/number into categories
#Why do this?
# - statistical models
# - plotting e.g. order of appearance (x axis); divergent colors

#factors are different from characters
# - they are converted to numbers under the hood;
# - they have levels

tt %>% mutate(fct_class = factor(Pclass)) %>% select(Pclass,fct_class) %>% str()

tt %>% mutate(fct_class = factor(Pclass)) %>% 
  ggplot(aes(y=Fare, x=Age)) + geom_point(aes(col=fct_class))

tt %>% mutate(fct_class = factor(Pclass)) %>% 
  ggplot(aes(x=fct_class,y=Age)) + geom_boxplot()

#factors have levels
tt %>% mutate(fct_class = factor(Pclass, levels=c(2,1,3))) %>% 
  ggplot(aes(x=fct_class,y=Age)) + geom_boxplot()







###############

#Joining biological data

#dplyr::left_join()

#Joining GO terms to genes, and then to GO descriptions.

#make a folder called 'GO_join' in
#MacOS: "~/Desktop/WEHI_R_workshop/"
#Windows: "C:/Users/your_username/Desktop/WEHI_R_workshop"
#Windows: "~/../Desktop/WEHI_R_workshop"

#Download the four tables located here http://tinyurl.com/entrez-joinGO into GO_join.

setwd("~/Desktop/WEHI_R_workshop/GO_join")

#setwd("~/Dropbox/R_teaching_materials/WEHI_IntroR_Course/Mar_2019/GO_join/")

entrez_FC <- read_csv("entrez_logFC.csv")
Hs_annot <- read_csv("Hs_annot.csv")
GO_entrez <- read_csv("GO_entrez.csv")
GO_terms <- read_csv("GO_terms.csv")

saveRDS()

#inspect each object
entrez_FC
Hs_annot 
GO_entrez 
GO_terms


entrez_FC %>% left_join(Hs_annot, by="entrez_id")

entrez_FC_annot <- entrez_FC %>% left_join(Hs_annot, by="entrez_id")

entrez_GO <- entrez_FC_annot %>% left_join(GO_entrez, by='entrez_id')

entrez_GO_term <- entrez_GO %>% left_join(GO_terms, by=c("go_id"="GOID"))
#when key has non-matching column names, use: by=c('key1_name' = 'key2_name')


entrez_GO_term %>% ggplot(aes(x=factor(entrez_id),y=logFC)) + 
  geom_col(aes(fill=TERM)) +
  facet_wrap(~ TERM,scale="free_x")


entrez_GO_term %>% ggplot(aes(x=symbol,y=logFC)) + 
  geom_col(aes(fill=TERM), show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~ TERM, scale="free_y", ncol=1) 
  

