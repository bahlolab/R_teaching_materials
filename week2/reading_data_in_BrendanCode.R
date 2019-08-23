#reading data in to R

library(tidyverse)

#read_csv reads a comma separated table

hdi_csv <- read_csv("~/Desktop/March19_WEHI_R_workshop/Human_Dvp_Index.csv",
                    col_names = TRUE)

hdi_csv %>% head()
hdi_csv %>% View()

hdi_csv %>% ggplot(aes(x=Mean_years_schooling, y=GNI_perCapita)) + 
  geom_point()


##### read in from excel
#either: Environment tab > Import Dataset > From Excel 

#or: 
library(readxl) #package to read from excel files

hdi_xl <- read_excel("~/Desktop/March19_WEHI_R_workshop/Human_Dvp_Index.xlsx",
           col_names = TRUE, sheet = 1)
?read_excel
