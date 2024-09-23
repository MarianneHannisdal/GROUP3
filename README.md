# Velcome to Group 3`s group project! 
## The group consists of Siren Hovland, Hildegunn Frønningen, Marianne Hannisdal 


**DATA** <br>
The DATA folder contains an exam_dataset.txt that was very untidy, we therefore tidyed it up using the "Tidy_Data_Main_script.R" resulting in a new dataset "tidy_exam_dataset.txt". It also contains the codebook describing the data we have used.

**SCRIPTS** <br>
The SCRIPTS folder contains all the scripts we have used, and is named according to the task they were used for. The scripts are named with numbers to define the chronological order in which they were written;

    "01_Tidy_Data_Main_Script.R" contains the code for tidying the data so that each row is one observation, each column is one variable.
    
    "02_Tidy_Adjust_Explore_Main_Script.R" contains the code for adjusting and exploring the dataset; 
        Adjusting e.g. by removing unnecessary columns, creating new set of columns, making necessary changes in variable types, arranging the order of columns, and reading/joining the additional dataset to the main dataset.           Exploring e.g. by identifying and commenting on missing variables, and stratify our data by a categorical column and report min, max, mean and sd of i) a numeric column, and ii) numeric column for a defined set of observations.
        
    "03_Creating_plots.R" contains the plots to answer the following questions:
        - Are there any correlated measurements?
        - Is there a relation between the `PVol` and `TVol` variables?
        - Does the distribution of `PreopPSA` depend on `T.Stage`?
        - Does the distribution of `PVol` depend on `sGS`?
        - Does the distribution of `TVol` depend on `sGS`?
        - Where there more `T.Stage == 2` in the group with `PreopTherapy == 1` than in `PreopTherapy == 0`?

    "04_analyzing_the_data.R" contains the code to answer the following questions:
        - Was the time to recurrence different for various `RBC.Age.Group` levels?
        - Was the time to recurrence different for various `T.Stage` levels?
        - Did having `AdjRadTherapy` affected time to recurrence?
        - Did those that had recurrence had also larger `TVol` values than those without recurrence?

**RESULTS** <br>
The RESULTS folder contains:
    - All the relevant plots we made in "03_Creating_plots.R" to answer the exam questions
    - The file "Final_report.rmd", containing plots and results from "04_analyzing_the_data.R"

