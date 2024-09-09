# Exam description

Practical task in groups (4-5 persons). 

You will create a GitHub repository or use the one you have created during the
course. There, you need to collaborate, keep history of changes, push commits,
etc. The log will be evaluated by us to check that each of you worked on a part
of the final report.

The repository should contain:

- _any scripts you have been using during the course_ (choose one version or
create a new one based on everyone's versions)
- _any notes or log files you think were useful_
- _tidied dataset_
- _new codebook for tidy data_
- _nice folder structure_
- _final .Rmd report and the .html or .md output_

## Data

You will receive an `exam_data.txt` file and the codebook describing the dataset
(`codebook_exam_data.html`).

## Tasks

1. Create an RStudio project.

    - create a nice folder structure, e.g., data, scripts folders, and put the
    dataset in `data`, create a new R script or Rmarkdown file in `scripts`
    - write a README and update its content as you go on

2. Day 5: Read and tidy the dataset.    
_(try to divide this task between the group members)_

    - write all the commands and document!
    - _tips:_
    
        - some columns may need to be separated
        - some columns can be duplicated
        - some column names can contain spaces or start with numbers
        - some columns can include values from various features/measurements

3. Day 6: Tidy, adjust, and explore.    
_(try to divide this task between the group members)_

    - Remove unnecessary columns from your dataframe: `AA, bGS, BNplus, OrganConfined`
    - Make necessary changes in variable types
    - Create a set of new columns:
        - A column showing whether `PVol` is higher than 100 or not: values High/Low
        - A numeric column showing `TimeToReccurence` in days (or weeks if you like)
        - A column showing `recurrence` as Yes/No
        - A numeric column showing multiplication of `AnyAdjTherapy` and `PreopTherapy` for each person
    - Set the order of columns as: `id, hospital, Age` and other columns
    - Arrange ID column of your dataset in order of increasing number or alphabetically.
    - Read and join the additional dataset to your main dataset.
    - Connect above steps with pipe.
    - Explore your data.
    - Explore and comment on the missing variables.
    - Stratify your data by a categorical column and report min, max, mean and sd of a numeric column.
    - Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations - use pipe!
        - Only for persons with `T.Stage == 1`
        - Only for persons with `Median.RBC.Age == 25`
        - Only for persons with `TimeToReccurence` later than 4 weeks
        - Only for persons recruited in `Hosp1` and `Tvol == 2`
    - Use two categorical columns in your dataset to create a table (hint: ?count)

4. Day 7: Create plots that would help answer these questions:
_(each person chooses min.one question)_

    - Are there any correlated measurements?
    - Is there a relation between the `PVol` and `TVol` variables?
    - Does the distribution of `PreopPSA` depend on `T.Stage`?
    - Does the distribution of `PVol` depend on `sGS`?
    - Does the distribution of `TVol` depend on `sGS`?
    - Where there more `T.Stage == 2` in the group with `PreopTherapy == 1` than in the group `PreopTherapy == 0`?

4. Day 8: Analyse the dataset and answer the following questions:
_(each person chooses one question)_

    - Was the time to recurrence different for various `RBC.Age.Group` levels?
    - Was the time to recurrence different for various `T.Stage` levels?
    - Did having `AdjRadTherapy` affected time to recurrence?
    - Did those that had recurrence had also larger `TVol` values than those without recurrence?

5. Write a short report in an Rmd format.    
_(divide writing the report)_

General tips:

- document, track changes (commit often!)
- use descriptive names, don't cram the code on a small space
- be active with commiting, commenting, etc.
- you can have many short scripts - one per each task, or two-three longer 
scripts logically divided and neatly commented

## What can be used?

Everything! Google if you get stuck, use books, blogs, R-docs...!

_NB: if you have any technical issues, contact us!_

## Evaluation

- We expect a clean history of changes and a nice structure of files.
- Documentation of the scripts needs to be informative.
- The code style will not be evaluated, but might influence our mood while
performing evaluation ;)

In the end, we would like to receive a repository that includes the files
listed on top of this document

## Grading

The project will be evaluated individually and you will get
an exhaustive description of your work, taking into account:

    - cleanliness of the files and file structure,
    - usage of the functions to complete the tasks described above,
    - the overall content of the final report.

