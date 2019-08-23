#Week 2 summary

#create a vector and assign names to each value
#filter("subset") values in a vector by position ('index')
#filter("subset") values in a vector based on a comparison [T/F output; returns only T]

#dplyr::filter() use comparison (==; >= ; < ; != etc) to sub-set rows
#dplyr::filter() use logicals combined with comparisons  ( a > b & d != c ) to sub-set rows

#dplyr::select() columns
#dplyr::arrange() by value
#dplyr::mutate() create new column by transforming existing column(s)



#Week 3 dplyr_continued

#Learning outcomes:
  #handy extensions for dplyr
  #group and summarize data to get detailed summaries



###############

library(tidyverse)

#titanic dataframe
tt <- read_csv("https://goo.gl/4Gqsnz")

tt %>% head() #not Titanic!

#view structure of titanic data frame 
tt %>% dim()   #dimensions n rows, n cols

#plot age by fare, color by Pclass
tt %>% ggplot(aes(y=Fare, x=Age)) + 
  geom_point(aes(col=Pclass))

#plot an orange coloured histogram of fare
tt %>% ggplot(aes(x=Fare)) + geom_histogram(fill="orange")

#Challenge: how many females who did not survive, paid more than 30 pounds for their ticket?
tt %>% filter(Sex=="female" & Fare>30 & Survived==0) 




############ ############

#Handy DPLYR extensions

#dplyr::filter with str_detect. very useful
tt %>% filter(str_detect(Name,"Mrs")) %>% head()

# filter(colName %in% vector)
tt %>% filter(Pclass %in% c(2,3)) %>% count(Pclass)


#dplyr::select(everything())
tt %>% select(4,7,everything())  #note everything() is a function. needs ()

#dplyr::mutate. ifelse() ; case_when()
tt %>% mutate(status=ifelse(Age<18 , 'child','adult')) %>% 
  select(status,everything())

tt %>% mutate(luck = case_when( Pclass ==1 & Survived ==0 ~ 'v_unlucky',
                                Pclass==3 & Survived ==1 ~ 'v_lucky',
                                Survived ==1 ~ 'lucky', 
                                TRUE ~ 'unlucky')) %>% count(luck)



#Challenge

#make rounded fare and assign to new variable
tt_roundFare <- tt %>% mutate(roundFare=round(Fare))


# - find the median round fare
# mutate make a field called faretype
# - budget label for fares less than the median round fare, 
# - delux for fares greater than the median round fare 
tt_roundFare %>% summarize(median=median(roundFare))

tt_roundFare %>% mutate(fare_type = ifelse(roundFare < 14, 'budget','delux')) %>% 
  dplyr::select(fare_type,everything())

#10:30am

#verb 5. summarize() /summarise()

tt %>% summarize(mean_age=mean(Age))
tt %>% summarize(mean_age=mean(Age, na.rm=TRUE)) #removes NA values

#average age of men on the titanic?
tt %>% filter(Sex=="male") %>% summarize(meanM_age=mean(Age, na.rm=TRUE))


#group_by! creates multiple smaller data_frames, and runs subsequent functions on each.
tt %>% group_by(Pclass) %>% summarize(mean_age=mean(Age, na.rm=TRUE))

#passengers of unknown age are annoying. Let's remove them.
tt_age <- tt %>% filter(!is.na(Age))


#summarize two columns
tt_age %>% group_by(Pclass) %>% 
  summarize(mean_age = mean(Age),
            mean_fare = mean(Fare))

#group and summarize
tt_age %>% na.omit() %>% group_by(Pclass,Sex) %>% summarize(mean_age=mean(Age),
                                          median_age=median(Age),
                                          sd_age=sd(Age),
                                          max_fare=max(Fare))

#store your summary
tt_summary <- tt_age %>% group_by(Pclass,Sex) %>% summarize(mean_age=mean(Age),
                                                                      median_age=median(Age),
                                                                      sd_age=sd(Age),
                                                                      max_fare=max(Fare))


#summarize(n()) to count rows
tt_age %>% group_by(Pclass,Sex) %>% summarize(groupTotal=n())  #714 in total

#count() to sum by category.
tt_age %>% count(Pclass)
tt_age %>% count(Pclass==3)



