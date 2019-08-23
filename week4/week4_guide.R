#week4_draft.R


#AUTOMATION
#cheatsheets!!
#assign dplyr output to variables
#write tabular output to csv

#for loops

#paste(); distinct()
#save and load environment

##############
##############


library(tidyverse)

CHEATSHEETS
https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

#Finish up tidyr. Two commands for separating and uniting columns
#We will use data that comes pre-packaged with R called table3 and table5
#TB cases

#separate()
table3 %>% head()

#R will guess the separator!
table3 %>% separate(col = rate,
                    into=c('cases','population'),
                    sep="/") 

#unite()
table5 %>% head()

table5 %>% unite(col='year', century, year, sep="") %>% 
  mutate(year=as.numeric(year))


###################
###################




#paste0. we need this for keeping track of automated scripts. pastes variables together with fixed strings.

paste("hello","world") #space
paste0("hello","world") #noSpace

#vectorization
paste0("hello", c(1,2,3)) 


#for loops

for(i in 1:5){
  print(i)
}



i <- 'baby'
paste(i, 'shark do do do do')

sharks <- c('baby','mummy','daddy')

for(i in sharks){print(i)}

#we assign the result to a variable inside the loop. then print the variable.
for(i in sharks){
  songLine <- paste(i,'shark do do do do')
  print(songLine)
}




###################
###################


### READ UNDERSCORE CSV!!

#screening plates here: http://tinyurl.com/screening-plates 

setwd("~/Desktop/March19_WEHI_R_workshop/screening_plates/")

myPlate <- read_csv("PLATE1.csv")


#gather()  #many columns same data type >> 2 columns: key (= colname) and value
#often required for plotting. each aes() must refer to data in a single column.

myPlate %>% gather(contains('C'),key ="COL",value="LUMIN") %>% 
  ggplot(aes(x=COL,y=LUMIN)) + geom_boxplot(aes(colour=COL), show.legend = FALSE)

#assign the long-format plate into a variable
plate_long <- myPlate %>% gather(contains('C'),key ="COL",value="LUMIN") 

#spread()
plate_long %>% spread(key="COL",value="LUMIN") %>% head() #out of order

paste0("C",1:48)

plate_long %>% spread(key="COL",value="LUMIN") %>% select(ROW, paste0("C",1:48)) %>% head()

plate_long %>% ggplot(aes(x = LUMIN)) + geom_density()
#Note mean value


#change the data type so we can order our plot rows to resemble the plate
plate_long_num <- plate_long %>% 
  mutate(ROW = str_remove(ROW,"R")) %>% 
  mutate(COL = str_remove(COL,"C")) %>% 
  mutate(ROW = as.numeric(ROW),
         COL = as.numeric(COL)) 

#ROW is A:H
plate_long_num %>%  ggplot(aes(x=COL, y=ROW, fill=LUMIN)) + 
  geom_tile(col="grey") +
  scale_y_reverse() +
  scale_fill_gradient2(low="blue", mid="white",high="red", midpoint = 2e5) #approximate mean from histogram above

ggsave("output_files/plate1.pdf",width=8, height=5)


#Col 1,23,25 and 47 are positive controls (100% kill, or no cells (empty wells))
#Negative controls (no drug) harder to identify. \ We know from Kym Lowes that these are cols 2,24,26 and 48.


#label controls

#lets label the columns as test, positive or negative control:

plate_long_num %>%  
  mutate(wellTag = case_when(COL %in% c(1,23,25,47) ~ 'posCTRL',
                             COL %in% c(2,24,26,48) ~ 'negCTRL',
                             TRUE ~ 'test')) %>% count(wellTag)

#store tagged data in a variable

plate_tagged <- plate_long_num %>%  
  mutate(wellTag = case_when(COL %in% c(1,23,25,47) ~ 'posCTRL',
                             COL %in% c(2,24,26,48) ~ 'negCTRL',
                             TRUE ~ 'test')) 


#compute mean & sd for neg. control

meanNeg <- plate_tagged %>% filter(wellTag=="negCTRL") %>% 
  summarize(meanNeg=mean(LUMIN)) %>% pull(meanNeg)

sdNeg <-  plate_tagged %>% filter(wellTag=="negCTRL") %>% 
  summarize(sdNeg=sd(LUMIN)) %>% pull(sdNeg)

#calculate z score for test wells 
plate_zScores <- plate_tagged %>%
  filter(wellTag == "test") %>% 
  mutate(z_score = (LUMIN - meanNeg)/sdNeg) 



hits <- plate_zScores %>% filter(z_score < (-4) | z_score > 4) %>% arrange(z_score)

write_csv(hits, path="output_files/PLATE1_hits.csv")


