To clear up the initially messy Samsung database

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

which full description is available at 

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

One should

  1. Download and unzip Samsung database into R working directory
     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

  2. Download into R working directory a script from this repo:
     run_analysis.R   

  3. Perform clearance procedure
```
  source("run_analysis.R");
  data <- uci.har.tide();
```

To get _cleared_and_aggregated_ database (see step 5 of the Coursera instruction at 
https://class.coursera.org/getdata-016/human_grading/view/courses/973758/assessments/3/submissions)
one can perform aggregation as well:

```
  source("run_analysis.R"); # if not loaded
  agg <- uci.har.aggregate();
```

Data codebook is available as <b>CodeBook.md</b> at this repo
