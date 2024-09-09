library(tidyverse)
library(here)
library(haven)
here()


MyData<-read.delim(here("DATA","exam_dataset.txt"))

head(MyData) 
