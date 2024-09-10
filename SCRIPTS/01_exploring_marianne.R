# Exploring the data ----

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

# Tidy the data ----
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


## Identifying PVol and TVol as a suboptimal variable ----
# Checking if the salient .value is numeric
class(MyData$.value)

# Reshape the data PVol and TVol
MyData_wide <- MyData %>%
  pivot_wider(
    names_from = volume.measurement,   # This specifies where to get the names of the new columns
    values_from = .value,              # This specifies where to get the values that will fill the new columns
    #names_prefix = ""                  # This can be adjusted if you need a specific prefix for column names
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

# Rename the column X1_Age to Age
MyData <- MyData %>%
  rename(Age = X1_Age)

# View the first few rows to confirm the change
head(MyData)

# Display the time to recurrence columns
MyData %>% 
  select(TimeToRecurrence, TimeToRecurrence_unit)

MyData <- MyData %>% 
  mutate(TimeToRecurrence_days = if_else(TimeToRecurrence_unit == "week", TimeToRecurrence*7, TimeToRecurrence))


MyData %>% 
  select(TimeToRecurrence, TimeToRecurrence_unit, TimeToRecurrence_days)


#fileName <- paste0("exam_dataset_", Sys.Date(), ".txt")write_delim(MyData, 
            file = here("DATA", fileName), delim="\t")
