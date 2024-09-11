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
library(dplyr)

# Reading the file
MyData<-read.delim(here("DATA","tidy_exam_dataset.txt"))

# Getting an overview
skimr::skim(MyData)

# Rearrange the code, in the format of a pipe
MyDataNew <- MyData %>%
  select(-AA, -bGS, -BN., -OrganConfined) %>%
  mutate (subject = as.numeric(subject)) %>%
  arrange(subject) %>%
  mutate(VolumeHighOrLow = ifelse(PVol > 100, "High", "Low")) %>%
  mutate(recurrence = ifelse(Recurrence == 0, "No", "Yes")) %>%
  mutate(TotalTherapy = AnyAdjTherapy * PreopTherapy) %>%
  select(subject, Hospital, Age, everything())


# Joining datasets ----
# Read and join the additional dataset to your main dataset.
# Organizing in a pipe
MyData2<-read.delim(here("DATA","exam_joindata.txt")) %>%
  rename(subject = id)

# Now we can join by matching "subject". MyData2 has 200 rows and MyData has 316
# Perform a full join by "subject"
full_data <- MyData %>%
  full_join(MyData2, by = "subject")

# looks good, so we overwrite full_data to MyData
MyData <- full_data

# Saving the dataset with a Tidy name
fileName <- paste0("tidy_adjust_exam_dataset", ".txt")
write_delim(MyData, 
            file = here("DATA", fileName), delim="\t")

# Exploring the new joined dataset
skimr::skim(MyData)
view(MyData)
