#week4_loop_draft.R


library(tidyverse)

myDir <- "~/Desktop/March19_WEHI_R_workshop/screening_plates/"

setwd(myDir)

plate_files <- list.files(myDir, pattern="PLATE")

plates <- str_remove(plate_files,".csv")

for(i in plates){
myPlate <- read_csv(paste0(i,".csv"))

#assign the long-format plate into a variable
plate_long <- myPlate %>% gather(contains('C'),key ="COL",value="LUMIN") 

plate_long_num <- plate_long %>% 
  mutate(ROW = str_remove(ROW,"R")) %>% 
  mutate(COL = str_remove(COL,"C")) %>% 
  mutate(ROW = as.numeric(ROW),
         COL = as.numeric(COL)) 

plate_long_num %>%  ggplot(aes(x=COL, y=ROW, fill=LUMIN)) + 
  geom_tile(col="grey") +
  scale_y_reverse() +
  scale_fill_gradient2(low="blue", mid="white",high="red", midpoint = 2e5) #approximate mean from histogram

ggsave(paste0("output_files/",i,".pdf"),width=8, height=5)


#Col 1,23,25 and 47 are positive controls (100% kill, or no cells (empty wells))
#Negative controls (no drug) harder to identify. \ We know from Kym Lowes that these are cols 2,24,26 and 48.


#label controls

#lets label the columns as test, positive or negative control:
#store tagged data in a variable

plate_tagged <- plate_long_num %>%  
  mutate(wellTag = case_when(COL %in% c(1,23,25,47) ~ 'posCTRL',
                             COL %in% c(2,24,26,48) ~ 'negCTRL',
                             TRUE ~ 'test')) 


#mean & sd for neg. control

meanNeg <- plate_tagged %>% filter(wellTag=="negCTRL") %>% 
  summarize(meanNeg=mean(LUMIN)) %>% pull(meanNeg)

sdNeg <-  plate_tagged %>% filter(wellTag=="negCTRL") %>% 
  summarize(sdNeg=sd(LUMIN)) %>% pull(sdNeg)


#calculate z score for test wells 
plate_zScores <- plate_tagged %>%
  filter(wellTag == "test") %>% 
  mutate(z_score = (LUMIN - meanNeg)/sdNeg) 



hits <- plate_zScores %>% filter(z_score < (-4) | z_score > 4) %>% arrange(z_score)

write_csv(hits, path=paste0("output_files/",i,"_hits.csv"))
}

