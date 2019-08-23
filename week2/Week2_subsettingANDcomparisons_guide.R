#Week 2

##Lesson Plan


#Selecting sub-sets of our data which is crucial regardless of what coding language you use.
#start with sub-setting vectors (sequence of values)
#then sub-set data frames using the dplyr() family of commands
#introduce you to five simple functions that can be chained together (piped together)
#to achieve complex results!

#subSetting vectors in base R.

#often we're only interested in a sub-set of data.
#when we select based on certain conditions, we are Filtering or Sub-setting.
#do this in excel with the filter tab. which works fine until you want to do something else with your data like
#vlookup, transpose or even copy and paste.

#create a vector for the DOB of world's greatest pop band

1940,1940,1942,1943 #why doesnt this work?
c(1940, 1940, 1942, 1943)

#now assign to a variable / object called 'beatles'
beatles <- c(1940, 1940, 1942, 1943)

#who is who? We can add labels to this vector, using names()
names(beatles)   #name for a value #this is technically an attribute of the vector
names(beatles) <- c('John','Ringo','Paul','George')

#named vector
beatles
beatles %>% str()
names(beatles)


### Start subsetting ###

### 1. Subset by position (aka index)

#the square bracket!!
beatles[3]

beatles[c(2,3)]   #positions 2 and 3 only
beatles[c(1,3,4)]  #non-continuous positions
2:4   #sequence 2,3,4.
beatles[2:4]
beatles[-3]     #negation. everything except value in position 3.

### 2. Subset by value

#COMPARISONS

# = is assign (used outside of a function) and used to specify arguments (inside e.g. ggplot(aes()). 
# == is exactly equal to

#any time we use a comparison symbol, we expect an answer either TRUE or FALSE
beatles == 1940
beatles == c(1940,1943)

beatles > 1942
beatles >= 1942

#we can use these TRUE / FALSE answers to sub-set the vector

beatles[c(FALSE,FALSE,TRUE,TRUE)]
beatles[c(F,F,T,T)]

#because we know this gives an output of TRUE FALSE (a vector of logicals) 
beatles >= 1942
#we can use it in place of c(F,F,T,T)
beatles[beatles >= 1942] #returns all positions in the vector where the value is >= 1942

#similarly
beatles != 1943
beatles[beatles != 1943]

#in fact we can use ANYTHING that gives a T/F answer to subset our vector!
50 < c(20,200,300,40)
beatles[50 < c(20,200,300,40)]

### Subset by name
beatles == c("John","George") #doesnt work

#names(beatles) is a vector of characters, but it is just 'associated' with each of the numeric values in the vector.
names(beatles) == c("John","George") 

beatles[-"George"]    #negative subsetting doesnt work on names


#Challenge

#3 ways to extract the names and year of birth for all members born before 1943
#use 1. an index / value position, 2. a true/false vector, and 3. a comparison statement
beatles[c(1,2,3)]
beatles[c(1940,1942)] #this fails: equivalent to 'give me values in position 1940 and position 1942!
beatles[1:3]; beatles[-4]

beatles[beatles<1943]
beatles[c(T,T,T)] #nb vector recycling...
beatles[c(T,T,T,F)]



