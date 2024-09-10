#----GROUP 3-------------------------####
# Date:  2024-09-10       
# Author:  The members of GROUP 3     
# Filename: Tidy_Data_Main_Script.R    
# Description:  Exploring and tidying the data
#               
#               
# Project: Exam
#-------------------------------------------###




# Tidy the data ----

## Importing data and libraries----
# Importing relevant packages
library(tidyverse)
library(here)
library(readxl)

# Reading the file
MyData<-read.delim(here("DATA","exam_dataset.txt"))

# looking at the columns, eye-balling for any obvious errors
head(MyData) 

# Getting an overview
skimr::skim(MyData)

summary(MyData)

glimpse(MyData)


# Making a plot of missing values
naniar::gg_miss_var(MyData)


## Identifying some errors: solving a column with two values ----
# Separate the first column
MyData <- MyData %>% 
  separate(col = subject, 
           into = c("Hospital", "subject"), 
           sep = "-")

# how does it look now?
head(MyData) 

## Check for duplicate rows ----
any(duplicated(MyData))

# Count duplicate rows
num_duplicates <- sum(duplicated(MyData))
print(num_duplicates)

# Reading about the unique function
?unique

# Remove duplicate rows
MyData_unique <- unique(MyData)

# Print the number of rows before and after removing duplicates
cat("Rows before removing duplicates:", nrow(MyData), "\n")
cat("Rows after removing duplicates:", nrow(MyData_unique), "\n")

# Checking again for duplicate rows
any(duplicated(MyData_unique))

# Overwrite MyData with the unique dataset
MyData <- unique(MyData)

