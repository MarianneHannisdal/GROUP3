#----GROUP 3-------------------------####
# Date:  2024-09-11      
# Author:  The members of GROUP 3     
# Filename: Tidy_Adjust_Explore_Main_Script.R    
# Description:  Tidy exploring and adjust the data
#               
#               
# Project: Exam
#-------------------------------------------###

## Importing data and libraries----
# Importing relevant packages
library(tidyverse)
library(here)
library(readxl)

# Reading the file
MyData<-read.delim(here("DATA","tidy_exam_dataset.txt"))


# Getting an overview
skimr::skim(MyData)

# Removing unnecessary columns from the dataset
MyData <- MyData %>%
  select(-AA, -bGS, -BN., -OrganConfined)

skimr::skim(MyData)


##############
# 
view(MyData)
class(subject)


# Arrange ID column in order of increasing number or alphabetically
arrange(subject)

