#WEHI R course. 

#this is a comment. ignored by R but useful for you.

1 + 100 
#simple maths in R

1 + 100 # CMD ENTER on the same line


#functions are built in
log(100)
sqrt(100)

#variables. symbol containing data
x <- 5   # <- variable assignment operator 
x

x + x

X #case sensitive

R_at_wehi <- log(100)
R_at_wehi

#vector: series of values of the same data type

#data type numeric. Has meaning in R. can do maths.
my_vector <- c(1,3,5,8,13)
my_vector + 50
log(my_vector)

#data type 'character'. Has no meaning in R
my_animals <- c("cat", "dog", "mouse", "chicken")

10 + my_animals


#data type 'logical'. TRUE, FALSE or NA.

my_logicals <- c(TRUE,FALSE,TRUE,TRUE)
TRUE
true #has no logical meaning

#character is the 'catch-all' data type
my_mixture <- c(15, "cat", TRUE)



#load a package using library()
library(tidyverse)


#the pipe!
#sends data on left into function on right in your code.
#   %>%   
  
#HOT KEY: CMD + SHIFT + M  
  
mpg %>% View()
View(mpg)

#mpg = data_frame. similar to spread sheet.
mpg %>% head() #shows first 6 lines 

##ggplot. a grammar of graphics

mpg %>% ggplot() #background

mpg %>% ggplot(aes(x = displ, y = cty))    
#x axis aesthetic will be mpg displ column.
#y axis aesthetic will be mpg cty column

mpg %>% ggplot(aes(x = displ, y = cty)) +
  geom_point()
#add a geometric representation in points

mpg %>% ggplot(aes(x = displ, y = cty)) +
  geom_point(col="red") +
  geom_line()
#building up our plot in layers of geoms.

#adding point color encoded in the mpg manufact. column.
mpg %>% ggplot(aes(x=displ, y=cty)) +
  geom_point(aes(col = manufacturer))

#break up the plot using facet
mpg %>% ggplot(aes(x=displ, y=cty)) +
  geom_point(aes(col = manufacturer)) +
  facet_wrap( ~ class)
#break up by class. uses 'tilde'. new plot per class


# larger data set: diamonds
#check the columns and data types
diamonds %>% head()
diamonds %>% head() %>% View()



#sample 2500 rows. using sample_n(). set.seed so we have the same sample
set.seed(1234)
d <- diamonds %>% sample_n(2500)

#compare cut and price
d %>% ggplot(aes(x = cut, y = price)) +
  geom_point() 

#use geom_jitter separate overplotting
d %>% ggplot(aes(x = cut, y = price)) +
  geom_jitter(size=0.5, alpha = 0.25, height = 0) 
#change size, transparency and jitter height using extra commands
#use height = 0 to avoid adding noise to y axis values.

#ask for help!
?geom_jitter()
?geom_bar()
?geom_col()

#Copy and paste EXAMPLES at bottom, then run the code.
p <- ggplot(mpg, aes(cyl, hwy))
p + geom_point()
p + geom_jitter()
?log()

#diamonds
diamonds %>% dim() #what are the dimensions? #nrows, ncolumns

#summary plot. geom_bar(). counts up rows per column value.
diamonds %>% ggplot(aes(x = cut)) +
  geom_bar()

#how is clarity distributed over cut?
diamonds %>% ggplot(aes(x = cut)) +
  geom_bar(aes(fill = clarity), position="dodge") +
  ggtitle('Diamond clarity by cut',
          subtitle = 'WEHI productions')

?geom_bar() #what other bar positions can you make?

#saving our plots.
#first, Session > set working directory
ggsave("diamond_plot.pdf")

#change dimensions of plot
ggsave("diamond_plot.pdf",width=6,height=6)

  
## Box plots & histograms

diamonds %>% ggplot(aes(x = cut, y = price)) +
  geom_boxplot(aes(col=cut), alpha=0)


diamonds %>% ggplot(aes(x = price)) +
  geom_histogram()

#increase number of bins= increase resolution

diamonds %>% ggplot(aes(x = price)) +
  geom_histogram(bins=200)
#any inconsistencies?

#zoom in on x axis using coord function
diamonds %>% ggplot(aes(x = price)) +
  geom_histogram(bins=200) +
  coord_cartesian(xlim = c(0,2500))


#changing 'look' of the plot

diamonds %>% ggplot(aes(x = price)) +
  geom_histogram(bins=200) +
  xlab('Price of diamonds $USD') +
  ylab('Number of diamonds') +
  theme_bw()


#overplotting fix: histogram + scatter plot
#geom_hex()

#install.packages("hexbin") 
library(hexbin)

diamonds %>% ggplot(aes(x = price, y = carat)) +
  geom_hex() +
  scale_x_log10()

#change x scale






