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

# Make necessary changes in variable types
MyData <- MyData %>%
  mutate (subject = as.numeric(subject))
class (MyData$subject)

# Create a column showing whether `PVol` is higher than 100 or not: values High/Low
MyData <- MyData %>%
  mutate(VolumeHighOrLow = ifelse(PVol > 100, "High", "Low"))

# Create a column showing `recurrence` as Yes/No
MyData <- MyData %>%
  mutate(recurrence = ifelse(Recurrence == 0, "No", "Yes"))

# Create a numeric column showing multiplication of `AnyAdjTherapy` and `PreopTherapy` for each person
MyData <- MyData %>%
  mutate(TotalTherapy = AnyAdjTherapy * PreopTherapy)

# - Read and join the additional dataset to your main dataset.
MyData2<-read.delim(here("DATA","exam_joindata.txt"))

View(MyData2)
skimr::skim(MyData)
skimr::skim(MyData2)

# We want to join the data by ID, but the ID is named "subject" in MyData, and "id" in MyData2
# change the dame of id to subject in MyData2
MyData2 <- MyData2 %>%
  rename(subject = id)

# Now we can join by matching "subject". MyData2 has 200 rows and MyData has 316
# Perform a full join by "subject"
full_data <- MyData %>%
  full_join(MyData2, by = "subject")
View(full_data)

# looks good, so we overwrite full_data to MyData
MyData <- full_data
View(MyData)

# Arrange ID column in order of increasing number or alphabetically
arrange(subject)

