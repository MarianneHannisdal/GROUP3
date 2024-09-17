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
library(ggplot2)

# Reading the file
MyData<-read.delim(here("DATA","tidy_adjust_exam_dataset.txt"))

# Getting an overview
glimpse(MyData)


# 4. Day 7: Create plots that would help answer these questions:


#- Are there any correlated measurements? ----

#  - Is there a relation between the `PVol` and `TVol` variables? ----
# Regression: viewing the data: hos does the regression line look like
MyData %>% 
  ggplot(aes(x = TVol, y = PVol)) +
  geom_point() + 
  geom_smooth(method = "lm")

# Calculate correlation and handle NA values by excluding them
correlation <- cor(MyData$PVol, MyData$TVol, use = "complete.obs")
print(correlation) # There is a negative correlation between PVol and TVol of -0,21, meaning that for every 1 TVol increases, PVol decreses with 0.21

#73 Does the distribution of `PreopPSA` depend on `T.Stage`?  HG!
  
  # T-test to find out if there is a significant differece
  t.test(MyData$PreopPSA~MyData$T.stage) %>%  
  broom::tidy() # Table showing there is a statistically significant. P-value 0,01

# Visulalizes by boxplot  
boxplot(MyData$PreopPSA~MyData$T.stage)

# 74 Does the distribution of `PVol` depend on `sGS`?          HG!   

boxplot(MyData$PreopPSA~MyData$sGS)
boxplot(MyData$PreopPSA~MyData$sGS, na.rm = T) # the to plots look exacly the same

# According to the boxplot PreopPSA does not seem to depend om SGS.  
# 
MyData %>% 
  ggplot(aes(x = sGS, y = PreopPSA)) +
  geom_point() + 
  geom_smooth(method = "lm")  

# Calculate correlation and handle NA values by excluding them
correlation <- cor(MyData$PreopPSA, MyData$sGS, use = "complete.obs")
print(correlation) # Collerlation calculatet to 0,071 which is not significant. 


#  - Where there more `T.Stage == 2` in the group with `PreopTherapy == 1` than in the group `PreopTherapy == 0`? ----
# Add a binary indicator for T.Stage == 2, explicitly handling NAs
My_Data <- MyData %>%
  mutate(T_Stage_2 = if_else(`T.stage` == 2, 1, if_else(is.na(`T.stage`), NA_integer_, 0)))
# Subset the data for PreopTherapy groups 0 and 1, excluding NAs in T_Stage_2
group_0 <- My_Data %>% 
  filter(`PreopTherapy` == 0, !is.na(T_Stage_2)) %>% 
  pull(T_Stage_2)

group_1 <- My_Data %>% 
  filter(`PreopTherapy` == 1, !is.na(T_Stage_2)) %>% 
  pull(T_Stage_2)

# Perform a t-test
t_test_result <- t.test(group_1, group_0, alternative = "greater")

# Print the results of the t-test
print(t_test_result) #p-value = 0.001023. The t-test results suggest that there is a statistically significant greater presence of T.Stage == 2 in the group with PreopTherapy == 1 compared to the group with PreopTherapy == 0.

# Show all of this in a plot:
# Prepare the summary data frame, excluding NAs in T_Stage_2
summary_data <- data.frame(
  PreopTherapy = factor(c(rep(0, length(group_0)), rep(1, length(group_1)))),
  T_Stage_2 = c(group_0, group_1)
)

# Exclude rows with NA in T_Stage_2
summary_data <- summary_data[!is.na(summary_data$T_Stage_2), ]

# Calculate the sum for each group
summary_plot_data <- summary_data %>%
  group_by(PreopTherapy) %>%
  summarise(Count = sum(T_Stage_2), .groups = 'drop')

# Print the summary data to check it
print(summary_plot_data)

# Plotting the counts of T.Stage == 2 by PreopTherapy group
ggplot(summary_plot_data, aes(x = PreopTherapy, y = Count, fill = PreopTherapy)) +
  geom_col() +
  scale_fill_manual(values = c("#3498db", "#e74c3c")) +
  labs(title = "Counts of T.Stage == 2 by PreopTherapy Group",
       x = "PreopTherapy Group",
       y = "Count of T.Stage == 2",
       fill = "Group") +
  theme_minimal()

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



