#----GROUP 3-------------------------####
# Date:  2024-09-11
# Author:  The members of GROUP 3: Siren Hovland, Hildegunn Frønningen, Marianne Hannisdal
# Filename: Creating_Plots.R
# Description:  Creating Plots
#
#
# Project: Exam
#-------------------------------------------###

# Importing data and libraries----
library(tidyverse)
library(here)
library(dplyr)
library(ggplot2)
library(corrplot)

# Reading the file
MyData <- read.delim(here("DATA", "tidy_adjust_exam_dataset.txt"))

# Getting an overview
glimpse(MyData)



# Creating plots that would help answer these questions:----


## - Are there any correlated measurements? ----
### ...Correlation Matrix - an overview ----

MyDataTest <- MyData %>%
  select(-Age, -Median.RBC.Age, -Hospital, -VolumeHighOrLow, -recurrence, -subject, -RBC.Age.Group)

round(cor(MyDataTest),
  digits = 2 # rounded to 2 decimals
)
corrplot(cor(MyDataTest, use = "pairwise.complete.obs"),
  method = "number",
  title = "Correlation matrix of the variables",
  type = "upper" # show only upper side
) # The plot gives an overview of what to explore further.

dev.copy(png, filename = "RESULTS/corrplot.png")
# Saving the displayed plot
dev.off()



## - Is there a relation between the `PVol` and `TVol` variables? ----

### - ...Correlation Plot - 'TVol' and 'PVol' ----

MyData %>%
  ggplot(aes(x = TVol, y = PVol)) +
  geom_point() +
  geom_smooth(method = "lm")

dev.copy(png, filename = "RESULTS/reg_plot_PVol_TVol.png")
# Saving the displayed plot
dev.off()

# Calculating correlation and handle NA values by excluding them
correlation <- cor(MyData$PVol, MyData$TVol, use = "complete.obs")
print(correlation) # There is a negative correlation between 'PVol' and 'TVol' of -0,21, meaning that for every 1 'TVol' increases, 'PVol' decreses with 0.21



## Does the distribution of `PreopPSA` depend on `T.Stage`? ----

# T-test to find out if there is a significant difference
t.test(MyData$PreopPSA ~ MyData$T.stage) %>%
  broom::tidy() # Table showing there is a statistically significant. P-value 0,01


### - ...Box plot - 'PreopPSA' and 'T.stage' ----
boxplot(MyData$PreopPSA ~ MyData$T.stage)
dev.copy(png, filename = "RESULTS/PreopPSA_depend_on_Tstage.png")
# Saving the displayed plot
dev.off()



## Does the distribution of `PVol` depend on `sGS`? ----
### - ...Box plot - 'PVol' & 'sGS' ----

boxplot(MyData$PVol ~ MyData$sGS)
boxplot(MyData$PVol ~ MyData$sGS, na.rm = T) # the to plots look exactly the same
dev.copy(png, filename = "RESULTS/PVol_depend_on_sGS.png")
# Saving the displayed plot
dev.off()
# According to the boxplot 'PreopPSA' does not seem to depend om 'SGS'.


# Removing rows with any NA values in either 'PreopPSA' or 'sGS' columns
clean_data <- na.omit(MyData[c("PVol", "sGS")])


# Using ANOVA on cleaned data
anova_result <- aov(PVol ~ factor(sGS), data = clean_data)
summary(anova_result)


### - ...Correlation Plot 'PreopPSA' & 'sGS' ----

MyData %>%
  ggplot(aes(x = sGS, y = PreopPSA)) +
  geom_point() +
  geom_smooth(method = "lm")


# Calculating correlation and handle NA values by excluding them
correlation <- cor(MyData$PreopPSA, MyData$sGS, use = "complete.obs")
print(correlation) # Correlation calculated to - 0,071. PreopPSA decreases 7 % when sGS increases by 1.



## Does the distribution of 'TVol' depend on 'sGS' ----
### - ...Grouped Barplot - 'sGS' and 'TVol' ----

MyDataBarplot <- MyData %>%
  select(TVol, sGS) %>%
  drop_na(sGS) %>%
  drop_na(TVol) %>%
  mutate(sGS = as.factor(sGS)) # Make sure sGS is treated as a factor

table(MyDataBarplot$TVol, MyDataBarplot$sGS) %>%
  barplot(beside = T, legend.text = c("TVol1", "TVol2", "TVol3"), main = "Surgical Gleason Score and Tumor Volume", xlab = "sGS", ylab = "count", las = 1)
dev.copy(png, filename = "RESULTS/TVol_depend_on_sGS.png")
# Saving the displayed plot
dev.off()

# ANOVA
anova_result <- aov(TVol ~ sGS, data = MyDataBarplot)
summary(anova_result) # the p-value is extremely small, providing strong evidence against the null hypothesis, suggesting that the differences in TVol across the groups defined by sGS are highly statistically significant



#  Where there more `T.Stage == 2` in the group with `PreopTherapy == 1` than in the group `PreopTherapy == 0`? ----
# Adding a binary indicator for T.Stage == 2, explicitly handling NAs

My_Data <- MyData %>%
  mutate(T_Stage_2 = if_else(`T.stage` == 2, 1, if_else(is.na(`T.stage`), NA_integer_, 0)))
# Subset the data for 'PreopTherapy' groups 0 and 1, excluding NAs in T_Stage_2
group_0 <- My_Data %>%
  filter(`PreopTherapy` == 0, !is.na(T_Stage_2)) %>%
  pull(T_Stage_2)

group_1 <- My_Data %>%
  filter(`PreopTherapy` == 1, !is.na(T_Stage_2)) %>%
  pull(T_Stage_2)

# Performing a t-test
t_test_result <- t.test(group_1, group_0, alternative = "greater")
print(t_test_result) # p-value = 0.001023. The t-test results suggest that there is a statistically significant greater presence of T.Stage == 2 in the group with PreopTherapy == 1 compared to the group with PreopTherapy == 0.

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
  summarise(Count = sum(T_Stage_2), .groups = "drop")

# Print the summary data to check it
print(summary_plot_data)

# Plotting the counts of 'T.Stage' == 2 by 'PreopTherapy' group
### - ...Barplot 'T.Stage' == 2 & 'PreopTherapy' ----

ggplot(summary_plot_data, aes(x = PreopTherapy, y = Count, fill = PreopTherapy)) +
  geom_col() +
  scale_fill_manual(values = c("#3498db", "#e74c3c")) +
  labs(
    title = "Counts of T.Stage == 2 by PreopTherapy Group",
    x = "PreopTherapy Group",
    y = "Count of T.Stage == 2",
    fill = "Group"
  ) +
  theme_minimal()

# Saving the plot
dev.copy(png, filename = "RESULTS/count_T2.png")
# Saving the displayed plot
dev.off()
unique(MyData$T.stage)


styler:::style_active_file()
