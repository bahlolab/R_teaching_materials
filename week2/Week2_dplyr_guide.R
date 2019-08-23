### The dplyr Verbs [week2.key]

library(tidyverse)

#verb1. dplyr::filter()

mpg %>% filter(year == 1999)
mpg %>% filter(class == "midsize")
mpg %>% filter(hwy >= 30)

##LOGICALS

mpg %>% filter(hwy >= 30 & class=="subcompact") #AND
mpg %>% filter(hwy >= 30 & class=="suv") #OR
mpg %>% filter(hwy >= 30 | class=="suv") #OR


#ANDs before ORs [?] ##can use brackets here!!

mpg %>% filter(class =="suv" |  manufacturer =="chevrolet" & hwy >= 30 ) %>% dim()

mpg %>% filter((class =="suv" |  manufacturer =="chevrolet") & hwy >= 30 ) %>% dim()



# verb2. dplyr::select() COLUMNS by Name; by Position (ordered left to right)

mpg %>% select(displ, hwy) #select columns by name
mpg %>% select(displ, hwy, manufacturer, class) #select columns by name
mpg %>% select(1,3,5,6) #select columns by number 
mpg %>% select(-c(5,7)) #negative selection

mpg %>% select(starts_with("c")) 
mpg %>% select(contains("y")) 

#challenge: find 2 ways to combine names and position numbers to select model, cty and displ [in that order]
names(mpg) #check names of columns in data_frame

mpg %>% select(displ,cty,model)
mpg %>% select(model,5,3)

# verb3. dplyr::arrange()  #excel sort
mpg %>% arrange(cty)
mpg %>% arrange(desc(cty))

mpg %>% arrange(displ,class) #smallest-largest engine size, per class.

#what is the maximum value for diamonds$table?



#### tea BREAK

#verb 4. dplyr::mutate() #add a new column based on existing columns

diamonds %>% mutate(AUD = price * 1.25) 
diamonds %>% mutate(volume = x*y*z) 

#challenge what is the most expensive dimond, by dollars per gram [carat]?
diamonds %>% mutate(price_perGram = price/carat) %>% arrange(desc(price_perGram))


#use dplyr to transform data, then pipe into ggplot
diamonds %>% mutate(price_perGram = price/carat) %>% 
  #filter(color=="E" & clarity=="VVS2" & cut=="Ideal") %>% 
  filter(clarity=="VVS2" & cut=="Ideal" & carat<1.1 & price < 5000) %>% 
  ggplot(aes(x=carat,y=price_perGram, col=color)) + 
  geom_point() +
  geom_smooth(method="lm") +
  geom_abline(lty=2) #+ coord_equal() #+
  xlim(0,5000)
  facet_wrap(~ color,scales="free")

#ifelse() to create factors based on continuous data
#case_when() to easily apply more complex rules.
  

#verb 5. dplyr::summarize() #create summaries of existing data
#summarize
diamonds %>% 
  filter(clarity=="VVS1") %>% 
  summarize(meanPrice=mean(price),
                       sdPrice=sd(price))
  
  
#verb 6. dplyr::group_by() # create groupings within data
#group_by
diamonds %>% 
  group_by(clarity) %>% 
  #group_by(clarity,cut) %>% 
  summarize(meanPrice=mean(price),
            sdPrice=sd(price))



## CHEAT SHEETS

## Reading in xlsx data.