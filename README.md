Getting and Cleaning Data Course Project
========================================

This file explains how to use "run_analysis.R" script.


* Download and unzip the file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip then rename the dir into "data".

* Set working dir with setwd() to the dir that contains "data" and "run_analysis.R"" script.

* The "run_analysis.R" script requires dplyr, run install.packages("dplyr") then run library(dplyr) commands in RStudio.

* Run source("run_analysis.R") command in RStudio.

* The script will generate an output file named "means_per_activity_per_subject.txt" (219 Kb) in the current dir that contains the data frame with 180 rows and 68 columns. It contains the the average of all 66 features (mean and std) for each of 6 activities and each of 30 subjects. See the CodeBook.md for more details.

* Then load the file into RStudio by running:
  meanData <- read.table("means_per_activity_per_subject.txt", header=TRUE)