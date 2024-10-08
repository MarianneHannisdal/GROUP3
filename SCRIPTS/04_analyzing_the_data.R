#----GROUP 3-------------------------####
# Date:  2024-09-25
# Author:  The members of GROUP 3: Siren Hovland, Hildegunn Frønningen, Marianne Hannisdal
# Filename: analyzing_the_data.R
# Description: Analyzing the data
#
#
# Project: Exam
#-------------------------------------------###




# Analyzing the data ----

# Importing data and libraries----
# Importing relevant packages
library(tidyverse)
library(here)
library(readxl)

# Reading the file
MyData <- read_delim(here("DATA", "tidy_adjust_exam_dataset.txt"))


## Was the time to recurrence different for various `RBC.Age.Group` levels?----

### Calculating max and min values for TimeToRecurrence_days by RBC.Age.Group
MyData %>%
  select(RBC.Age.Group, TimeToRecurrence_days) %>%
  mutate(TimeToRecurrence_days = as.numeric(TimeToRecurrence_days)) %>%
  group_by(RBC.Age.Group) %>%
  summarise(min(TimeToRecurrence_days, na.rm = T), max(TimeToRecurrence_days, na.rm = T))


### Calculating the mean value for TimeToRecurrence_days by RBC.Age.Group
MyData %>%
  group_by(RBC.Age.Group) %>%
  summarise(mean(TimeToRecurrence_days, na.rm = T))


### Normal distribution or not by using histogram?

hist(MyData$TimeToRecurrence_days)
dev.copy(png, filename = "RESULTS/histogram.png")
# Saving the displayed plot
dev.off()
### The TimeToRecurrence is not normally distributed so T test is not relevant.

### Drawing a boxplot

boxplot((MyData$TimeToRecurrence_days ~ MyData$RBC.Age.Group), na.rm = T, main = "Boxplot - TimeToRecurrence by Age Groups")
dev.copy(png, filename = "RESULTS/Boxplot_TimeToRecurrence_by_RBC_Age_group.png")
# Saving the displayed plot
dev.off()

### Anova. Might work even if the data are not normally distributed

ANOVAresult <-
  MyData %>%
  mutate(TimeToRecurrence_days = log(TimeToRecurrence_days)) %>%
  aov(TimeToRecurrence_days ~ RBC.Age.Group, data = .)

ANOVAresult %>%
  summary()

### The P-value (Pr(>F))= 0.755. Not a statistically significant difference but a numeric difference.

### Kruskal-Wallis Test

kruskal.test(TimeToRecurrence_days ~ RBC.Age.Group, data = MyData)
# a P-value og 0,592 is not significant.
# there is a numerical value that is not statistically significant.


## - Was the time to recurrence different for various `T.Stage` levels? ----


TimeToRec_strat_by_Tstage <- MyData %>%
  group_by(T.stage) %>%
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )

TimeToRec_strat_by_Tstage

# The mean time to recurrence was clealy different between the two T-stage groups.
# For patients with T-stage 1 the mean time to recurrence was 246 (Std.dev 204) days.
# For patients with T-Stage 2 the mean time to recurrence was only 150 (std.dev 159) days.
# The differende can altso be wiaualised by a boxplot
boxplot((MyData$TimeToRecurrence_days ~ MyData$T.stage), na.rm = T, main = "Boxplot - TimeToRecurrence by Tstage")

dev.copy(png, filename = "RESULTS/Boxplot_TimeToRecurrence_by_Tstage.png")
# Saving the displayed plot
dev.off()


# histogram only shows that the time to recurrence is not normally distributed,
# it does not tell if the two different groups are normally distibuted.
hist(MyData$TimeToRecurrence_days)

# using the Kruskal-Wallis Test
kruskal.test(TimeToRecurrence_days ~ T.stage, data = MyData)
# a P-value of 0,0048 is clearly statistically significant.

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

# TimeToRec_strat_by_Tstage_1


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

TimeToRec_for_Hosp1_Tvol_2 <- MyData %>%
  filter(Hospital == "Hosp1") %>%
  group_by(T.stage) %>%
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )
TimeToRec_for_Hosp1_Tvol_2


# Illustarted by ggplots

MyData %>%
  ggplot(aes(x = T.stage, y = TimeToRecurrence_days)) +
  geom_point() +
  geom_smooth(method = "lm")

# Calculate correlation and handle NA values by excluding them
correlation <- cor(MyData$TimeToRecurrence_days, MyData$T.stage, use = "complete.obs")
print(correlation) # Calculated value -0.1517019.

# Time to recurrence is 15 % longer in those with T stage 1 than T stage 2.


## - Did having `AdjRadTherapy` affected time to recurrence? ----

# Exploring: See unique values in the AdjRadTherapy column
unique_values <- unique(MyData$AdjRadTherapy)
print(unique_values) # only 0 and 1

# Count the frequency of each value in the AdjRadTherapy column
frequency_table <- table(MyData$AdjRadTherapy)
print(frequency_table) # AdjRadTherapy==1 only occured once, rest was 0

# Calculate mean time to recurrence for both groups
mean_time_to_recurrence <- MyData %>%
  group_by(AdjRadTherapy) %>%
  summarise(
    MeanTimeToRecurrence = mean(TimeToRecurrence_days, na.rm = TRUE),
    .groups = "drop"
  )

# Print the results
print(mean_time_to_recurrence)

# Subset data for t-test
time_recurrence_0 <- MyData %>%
  filter(AdjRadTherapy == 0) %>%
  pull(TimeToRecurrence_days)

time_recurrence_1 <- MyData %>%
  filter(AdjRadTherapy == 1) %>%
  pull(TimeToRecurrence_days)

# Perform two-sided t-test
t_test_result <- t.test(time_recurrence_1, time_recurrence_0, alternative = "two.sided", na.rm = TRUE)
# Error in t.test.default(time_recurrence_1, time_recurrence_0, alternative = "two.sided",  : not enough 'x' observations

# Perform one-sided t-test to see if the mean time to recurrence is greater for AdjRadTherapy == 1
t_test_result <- t.test(time_recurrence_1, time_recurrence_0, alternative = "greater", na.rm = TRUE)
# Error: not enough 'x' observations

# Print the results of the t-test
print(t_test_result) # No result due to error

# What about AnyAdjTherapy in stead of AdjRadTherapy?

# Count the frequency of each value
frequency_table <- table(MyData$AnyAdjTherapy)
print(frequency_table) # 7 observations of 1, rest 0

# Assuming AnyAdjTherapy is also a binary indicator (0 and 1)
mean_time_to_recurrence_anyadj <- MyData %>%
  group_by(AnyAdjTherapy) %>%
  summarise(
    MeanTimeToRecurrence = mean(TimeToRecurrence_days, na.rm = TRUE),
    .groups = "drop"
  )

# Print the results
print(mean_time_to_recurrence_anyadj)

# Subset data for t-test
time_recurrence_any_0 <- MyData %>%
  filter(AnyAdjTherapy == 0) %>%
  pull(TimeToRecurrence_days)

time_recurrence_any_1 <- MyData %>%
  filter(AnyAdjTherapy == 1) %>%
  pull(TimeToRecurrence_days)

# Perform one-sided t-test to see if the mean time to recurrence is greater for AnyAdjTherapy == 1
t_test_result_any <- t.test(time_recurrence_any_1, time_recurrence_any_0, alternative = "greater", na.rm = TRUE)

# Print the results of the t-test
print(t_test_result_any) # p-value = 0.7421 No significant difference in mean due to power



## - Did those that had recurrence had also larger `TVol` values than those without recurrence? ----

# Count the frequency of each value
frequency_table <- table(MyData$TVol)
print(frequency_table) # Tvol 1 counted 64, Tvol 2 counted 153, Tvol 1 counted 93

MyData %>%
  count(Recurrence, T.stage)

# Create a table of counts for 'Tvol' and 'Recurrence' and printing the results
table_result <- table(MyData$TVol, MyData$Recurrence)
print(table_result)


table_with_NA <- table(MyData$TVol, MyData$Recurrence, useNA = "ifany")
print(table_with_NA)

styler:::style_active_file()
