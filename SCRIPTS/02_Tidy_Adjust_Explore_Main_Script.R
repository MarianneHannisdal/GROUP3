#----GROUP 3-------------------------####
# Date:  2024-09-23
# Author:  The members of GROUP 3: Siren Hovland, Hildegunn Frønningen, Marianne Hannisdal
# Filename: Tidy_Adjust_Explore_Main_Script.R
# Description:  Tidy exploring and adjust the data
#
#
# Project: Exam
#-------------------------------------------###

# Importing data and libraries----
library(tidyverse)
library(here)
library(dplyr)
library(styler)

# Reading the file
MyData <- read.delim(here("DATA", "tidy_exam_dataset.txt"))

# Wrangling the data, in the format of a pipe
MyDataWrangled <- MyData %>%
  select(-AA, -bGS, -BN., -OrganConfined) %>%
  mutate(subject = as.numeric(subject)) %>%
  arrange(subject) %>%
  mutate(VolumeHighOrLow = ifelse(PVol > 100, "High", "Low")) %>%
  mutate(recurrence = ifelse(Recurrence == 0, "No", "Yes")) %>%
  mutate(TotalTherapy = AnyAdjTherapy * PreopTherapy) %>%
  select(subject, Hospital, Age, everything())


# Joining datasets ----
# Read and join the additional dataset to your main dataset.
MyData2 <- read.delim(here("DATA", "exam_joindata.txt")) %>%
  rename(subject = id)

# Now we can join by matching "subject". MyData2 has 200 rows and MyData has 316
# Perform a full join by "subject"
full_data <- MyDataWrangled %>%
  full_join(MyData2, by = "subject")

# Visually inspecting if the join was successful before overwriting MyData
glimpse(full_data)

# looks good, so we overwrite full_data to MyData
MyData <- full_data

# Saving the dataset with a Tidy name
fileName <- paste0("tidy_adjust_exam_dataset", ".txt")
write_delim(MyData,
  file = here("DATA", fileName), delim = "\t"
)

# Exploring the data: ----
## Which columns contains NA-values? ----
MyDataNA <- MyData %>%
  select(where(~ any(is.na(.))))
glimpse(MyDataNA) # Displaying columns with NA

# Stratifying ----
## - our data by a categorical column and report min, max, mean and sd of a numeric column ----
# We Choose TimeToRecurrence_days grouped by T.stage
TimeToRec_strat_by_Tstage <- MyData %>%
  group_by(T.stage) %>%
  summarise(
    max_TimeToRec = max(TimeToRecurrence_days, na.rm = T),
    min_TimeToRec = min(TimeToRecurrence_days, na.rm = T),
    mean_TimeToRec = mean(TimeToRecurrence_days, na.rm = T),
    std_dev_TimeToRec = sd(TimeToRecurrence_days, na.rm = T)
  )

TimeToRec_strat_by_Tstage # Displaying a tibble


## - for a defined set of observations ----
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


## - for persons with `Median.RBC.Age == 25` ----
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


## - for persons with `TimeToReccurence` later than 4 weeks (28 days) ----
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

## - for persons recruited in `Hosp1` and `Tvol == 2` ----
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

# Use two categorical columns in your dataset to create a table ----
# We choose the columns "Recurrence" (0 1) and "T.Stage (1 2)
MyData %>%
  count(Recurrence, T.stage)



styler:::style_active_file()
