---
title: "Getting and Cleaning Data Course Project"

---


`dfActivity` merges the training `dfTrain` and the test `dfTest` sets to create one data set.

`features` is the vector with measurements labels.

`activs` merges the training `activTrain` and the test `activTest` activity sets to create one data set.

`activLabels` convert activities to descriptives names

`subjects` merges the training `subjectTrain` and the test `subjectTest` subjects sets to create one data set.

`dfActivityMelt` converts from a wide to narrow data.table using the keys created earlier
 
`tdTidy` reshapes the data to get the averages