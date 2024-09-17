#----GROUP 3-------------------------####
# Date:  2024-09-12       
# Author:  The members of GROUP 3     
# Filename: analyzing_the_data.R    
# Description: Analyzing the data
#               
#               
# Project: Exam
#-------------------------------------------###




# Analyzing the data ----

## Importing data and libraries----
# Importing relevant packages
library(tidyverse)
library(here)
library(readxl)

# Reading the file
MyData <- read_delim(here("DATA","tidy_adjust_exam_dataset.txt"))


# Was the time to recurrence different for various `RBC.Age.Group` levels?----

# Calculating max and min values for TimeToRecurrence_days by RBC.Age.Group 
MyData %>%
  select(RBC.Age.Group, TimeToRecurrence_days) %>%
  mutate(TimeToRecurrence_days = as.numeric(TimeToRecurrence_days)) %>%
  group_by(RBC.Age.Group) %>% 
  summarise(min(TimeToRecurrence_days, na.rm = T), max(TimeToRecurrence_days, na.rm = T))


# Calculating the mean value for TimeToRecurrence_days by RBC.Age.Group 
MyData %>% 
  group_by(RBC.Age.Group) %>% 
  summarise(mean(TimeToRecurrence_days, na.rm = T))

summarise(min(TimeToRecurrence_days, na.rm = T), max(TimeToRecurrence_days, na.rm = T))


# Normal distribution or not by using histogram?
hist(MyData$TimeToRecurrence_days)


# Drawing a boxplot 

boxplot((MyData$TimeToRecurrence_days ~ MyData$RBC.Age.Group), na.rm = T, main="Boxplot - TimeToRecurrence by Age Groups")


# Anova

MyData %>% 
  
  mutate(TimeToRecurrence_days = log(TimeToRecurrence_days)) %>%
  
  aov(TimeToRecurrence_days~RBC.Age.Group, data = .)

ANOVAresult <-
  
  MyData %>% 
  
  mutate(TimeToRecurrence_days = log(TimeToRecurrence_days)) %>%
  
  aov(TimeToRecurrence_days~RBC.Age.Group, data = .)

ANOVAresult %>%
  
  summary()

# Anova - test 2
MyData %>% 
  
  mutate(RBC.Age.Group = log(RBC.Age.Group)) %>%
  
  aov(RBC.Age.Group~TimeToRecurrence_days, data = .)

ANOVAresult <-
  
  MyData %>% 
  
  mutate(RBC.Age.Group = log(RBC.Age.Group)) %>%
  
  aov(RBC.Age.Group~TimeToRecurrence_days, data = .)

ANOVAresult %>%
  
  summary()

# RBC.Age.Group 2 inhibits lowest time to recurrence



#- Stratify your data by a categorical column and 
# report min, max, mean and sd of a numeric column.

# I Choose TimeToRecurrence_days grouped by T.stage

TimeToRec_strat_by_Tstage <- MyData %>% 
  group_by(T.stage) %>% 
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )

TimeToRec_strat_by_Tstage


#- Stratify your data by a categorical column and 
#report min, max, mean and sd of a numeric column 
# for a defined set of observations - use pipe!

# -Only for persons with `T.Stage == 1`

TimeToRec_strat_by_Tstage_1 <- MyData %>% 
  filter(T.stage == 1) %>%
  group_by(T.stage) %>% 
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )

TimeToRec_strat_by_Tstage_1


#- Only for persons with `Median.RBC.Age == 25`

TimeToRec_strat_by_Median.RBC.Age <- MyData %>% 
  filter(Median.RBC.Age == 25) %>%
  group_by(T.stage) %>% 
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
    )

TimeToRec_strat_by_Median.RBC.Age


#- Only for persons with `TimeToReccurence` later than 4 weeks
# skriver dager fordi vi har fjernet variabelen som viser

TimeToRec_strat_by_later_than_4_Weeks <- MyData %>% 
  filter(TimeToRecurrence_days >= 28) %>%
  group_by(T.stage) %>% 
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )

TimeToRec_strat_by_later_than_4_Weeks

#- Only for persons recruited in `Hosp1` and `Tvol == 2`

TimeToRec_for_Hosp1_Tvol_2  <- MyData %>% 
  filter(Hospital == "Hosp1") %>%
  group_by(T.stage) %>% 
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )
    TimeToRec_for_Hosp1_Tvol_2

#- Use two categorical columns in your dataset to create a table (hint: ?count)
  # We choose the columns "Recurrence" (0 1) and "T.Stage (1 2) 
    
MyData %>%
  count (Recurrence, T.stage)
    
    
#  4. Day 8: Analyse the dataset and answer the following questions:
#    _(each person chooses one question)_
# 82  - Was the time to recurrence different for various `T.Stage` levels?

t.test(MyData$TimeToRecurrence_days~MyData$T.stage) %>%  
  broom::tidy()
# P-value of 0.00233. there is a cleraly significant differece 

MyData %>% 
  ggplot(aes(x = T.stage, y = TimeToRecurrence_days)) +
  geom_point() + 
  geom_smooth(method = "lm")  

# Calculate correlation and handle NA values by excluding them
correlation <- cor(MyData$TimeToRecurrence_days, MyData$T.stage, use = "complete.obs")
print(correlation) # Calculatet value -0.1517019 which is significant. 

correlation <- cor(MyData$T.stage, MyData$TimeToRecurrence_days, use = "complete.obs")
print(correlation)

# Boxplot
boxplot(MyData$TimeToRecurrence_days~MyData$T.stage)

# 84  - Did those that had recurrence had also larger `TVol` values than those without recurrence?

t.test(MyData$TVol~MyData$Recurrence) %>%  
  broom::tidy()
# P-value of 0.0000000641 which is cleraly significant  

MyData %>% 
  ggplot(aes(x = Recurrence, y = TVol)) +
  geom_point() + 
  geom_smooth(method = "lm")  

# Plottet shows a clear difference between the two groups

# Calculate correlation and handle NA values by excluding them
correlation <- cor(MyData$TVol, MyData$Recurrence, use = "complete.obs")
print(correlation) # Calculatet value  0.2864918 which is significant. 


# Boxplot
boxplot(MyData$TVol~MyData$Recurrence)
# Boxplottet does nake make sence here 


