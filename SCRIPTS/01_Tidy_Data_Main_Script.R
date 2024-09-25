#----GROUP 3-------------------------####
# Date:  2024-09-25
# Author:  The members of GROUP 3: Siren Hovland, Hildegunn Frønningen, Marianne Hannisdal
# Filename: Tidy_Data_Main_Script.R
# Description:  Exploring and tidying the data
#
#
# Project: Exam
#-------------------------------------------###



# Importing data and libraries----
library(tidyverse)
library(here)
library(readxl)

## Reading the file
MyData <- read.delim(here("DATA", "exam_dataset.txt"))


# Getting an overview of the original dataset

# looking at the columns, eye-balling for any obvious errors
head(MyData)

# Getting an overview
skimr::skim(MyData)

summary(MyData)

glimpse(MyData)


# Tidying the original dataset ----

## Identifying missing values ----
naniar::gg_miss_var(MyData)


## Identifying columns consisting of more than one value ----
### --> Separate the first column ----
MyData <- MyData %>%
  separate(
    col = subject,
    into = c("Hospital", "subject"),
    sep = "-"
  )

# How does it look now?
head(MyData)

## Checking for duplicate rows ----
any(duplicated(MyData))

# Counting duplicate rows
num_duplicates <- sum(duplicated(MyData))
print(num_duplicates)

# Reading about the unique function
?unique

### --> Remove duplicate rows ----
MyData_unique <- unique(MyData)

# Printing the number of rows before and after removing duplicates
cat("Rows before removing duplicates:", nrow(MyData), "\n")
cat("Rows after removing duplicates:", nrow(MyData_unique), "\n")

# Checking again for duplicate rows
any(duplicated(MyData_unique))

# Overwrite MyData with the unique dataset
MyData <- unique(MyData)


## Identifying suboptimal variables ----

# Checking if the '.value' is numeric
class(MyData$.value)

### --> Reshape 'PVol' and 'TVol' ----
MyData_wide <- MyData %>%
  pivot_wider(
    names_from = volume.measurement, # Specifies where to get the names of the new columns
    values_from = .value, # Specifies where to get the values that will fill the new columns
    # names_prefix = ""   # Can be adjusted if a specific prefix for column names is needed
  )

# Print the first few rows to check the new structure
print(head(MyData_wide))

nrow(MyData_wide)

skimr::skim(MyData_wide)

# Overwrite MyData with the MyData_wide
MyData <- MyData_wide

# Display the new columns
MyData %>%
  select(PVol, TVol)

## Renaming to more tidy names ----
### - ..Rename 'X1_Age' to 'Age' ----
MyData <- MyData %>%
  rename(Age = X1_Age)

### ..Rename 'Unit' to 'allogeneic_units' ----
MyData <- MyData %>%
  rename(Allogeneic.units = Units)

### -..Replace spaces in all column names ----
MyData <- MyData %>%
  rename_with(~ gsub(" ", ".", .x))

skimr::skim(MyData)


# View the first few rows to confirm the changes
head(MyData)

## Tidying the variable 'TimeToRecurrence' ----

# Display the time to recurrence columns
MyData %>%
  select(TimeToRecurrence, TimeToRecurrence_unit)

### --> Add a new column where 'TimeToRecurrence' is defined in days ----
MyData <- MyData %>%
  mutate(TimeToRecurrence_days = if_else(TimeToRecurrence_unit == "week", TimeToRecurrence * 7, TimeToRecurrence))

MyData %>%
  select(TimeToRecurrence, TimeToRecurrence_unit, TimeToRecurrence_days)

### --> Remove 'TimeToRecurrence_unit' and 'TimeToRecurrence' ----
MyData <- MyData %>%
  select(-TimeToRecurrence_unit, -TimeToRecurrence)

skimr::skim(MyData)

# Saving the dataset with a tidy name ----
fileName <- paste0("tidy_exam_dataset", ".txt")
write_delim(MyData,
  file = here("DATA", fileName), delim = "\t"
)



styler:::style_active_file()
