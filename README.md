To clear up initially messy Samsung database

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A full description is available at 

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

To perform data clearing up one should:

  1. Download and unzip Samsung database into R working directory
     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

  2. Download into R working directory run_analysis.R script from this repo

  3. Perform clearance procedure
```
  source("run_analysis.R");
  data <- uci.har.tide();
```

To get _cleared_and_aggregated_ database (see step 5 of the Coursera instruction at 
https://class.coursera.org/getdata-016/human_grading/view/courses/973758/assessments/3/submissions)

```
  source("run_analysis.R"); # if not loaded
  agg <- uci.har.aggregate();
```
