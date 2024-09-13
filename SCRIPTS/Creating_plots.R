#----GROUP 3-------------------------####
# Date:  2024-09-11      
# Author:  The members of GROUP 3     
# Filename: Creating_Plots.R    
# Description:  Creatig Plots
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
library (patchwork)

# Reading the file
MyData<-read.delim(here("DATA","tidy_exam_dataset.txt"))

# Getting an overview
skimr::skim(MyData)


# 4. Day 7: Create plots that would help answer these questions:
#  _(each person chooses min.one question)_

#- Are there any correlated measurements?
#  - Is there a relation between the `PVol` and `TVol` variables?
#  - Does the distribution of `PVol` depend on `sGS`?
#  - Does the distribution of `TVol` depend on `sGS`?
#  - Where there more `T.Stage == 2` in the group with `PreopTherapy == 1` than in the group `PreopTherapy == 0`?
 
 