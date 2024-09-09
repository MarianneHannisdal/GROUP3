#2. Day 5: Read and tidy the dataset.    

#- some columns may need to be separated
#- some columns can be duplicated
#- some column names can contain spaces or start with numbers
#- some columns can include values from various features/measurements

# Importing relevant packages
library(tidyverse)
library(here)
library(readxl)

# Reading the file
MyData<-read.delim(here("DATA","exam_dataset.txt"))

head(MyData) 

# Separate
MyData %>% 
  separate(col = subject, 
           into = c("Hospital", "subject"), 
           sep = "-")
