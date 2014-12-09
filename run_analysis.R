# Convert messy smartphone database
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# into tidy one:
#   1. Training and test sets are merged together.    
#   2. Mean and standard deviation features are extracted, all the other ones are dropped
#   3. Original features are renamed (see the CodeBook for reference)  
#   4. Activity feature is converted into a factor 
# Prerequisits:
#   You should have set working directory to "UCI HAR Dataset" or provide a path to it
# Examples:
#   setwd("C:/Work/BigData/Coursera/UCI HAR Dataset")
#   d1 <- uci.har.tide();
#   d2 <- uci.har.tide("C:/Work/BigData/Coursera/UCI HAR Dataset"); 
#
# agg1 <- uci.har.aggregate();
# agg1 <- uci.har.aggregate("C:/Work/BigData/Coursera/UCI HAR Dataset");
#
uci.har.tide <- function(path=NULL) {
  # Root directory for "UCI HAR Dataset"
  data.RootDir <- function(path) {
    if (is.null(path)) {
      return("");
    }
    else if (path == "") {
      return("");
    }
    else if (grepl("/$", path) > 0) {
      return(path);
    }
    else if (grepl("\\\\$", path) > 0) {
      return(path);
    }

    paste(path, "/", sep="")
  }

  #Activities levels' to be converted to factor
  activities.Names <- function(path) {
    root <- data.RootDir(path); 

    activities <- read.table(paste(root, "activity_labels.txt", sep = ""));
    names(activities) <- c("Id", "Name");

    activities[order(activities$Id),]
  }

  # Update features' names:
  #   T       -> Time-
  #   F       -> Freq-
  #   Body    -> Body- 
  #   Gravity -> Gravity-
  #   mean()  -> 
  #   std()   -> StdErr
  #   -       -> .  
  update.Features.Names <- function(features) {
    find <- c("^t", "^f", "Body", "Gravity", "\\mean\\(\\)", "std\\(\\)");
    replace <- c("Time-", "Freq-", "Body-", "Gravity-", "Mean", "StdErr");

    # First Only
    for (i in 1:length(find))
      features$Name <- sub(find[i], replace[i], features$Name);

    # All 
    features$Name <- gsub("-", ".", features$Name);

    # features[order(features$Name),]

    features
  } 

  # Features to preserve in a raw data set:
  #  - mean values
  #  - standard error values
  features.Names <- function(path) {
    root <- data.RootDir(path);  

    features <- read.table(paste(root, "features.txt", sep=""));
    names(features) <- c("Original.Number", "Name");

    means.col <- grep("\\-mean\\(\\)", features$Name);
    stds.col <- grep("\\-std\\(\\)", features$Name);

    features <- features[c(means.col, stds.col),]

    features <- update.Features.Names(features);

    features <- features[with(features, order(features$Name)),]

    features$Name <- gsub("\\.Mean", "", features$Name);

    # Debug purpouse    
    # features <- cbind(features, 1:nrow(features));
    # names(features) <- c("Original", "Name", "Actual");

    features
  }

  # Read and combine data from eiter test or train subdirectory
  data.LoadCore <- function(path, kind, features) {
    root <- data.RootDir(path); 

    # Main data (features)
    data <- read.table(paste(root, kind, "/X_", kind, ".txt", sep=""));

    data <- data[features$Original];
    names(data) <- features$Name;

    # Corresponding activity (e.g. Standing, Walking etc.)
    activity <- read.table(paste(root, kind, "/y_", kind, ".txt", sep=""));
    names(activity) <- c("Activity");

    # Corresponding subject (e.g. person with Id = 1, Id = 5 etc.)
    subject <- read.table(paste(root, kind, "/subject_", kind, ".txt", sep=""));
    names(subject) <- c("Subject");

    data <- cbind(subject, activity, data);

    data
  }

  # Loading test and train data
  # combining them into final tidy data set
  # Applying type conversions (changing into factors) 
  data.Load <- function(path) {
    features <- features.Names(path);

    d1 <- data.LoadCore(path, "test", features);
    d2 <- data.LoadCore(path, "train", features);

    result <- rbind(d1, d2)

    # Activity is, in fact, a factor
    activities <- activities.Names(path);

    result$Activity <- as.factor(result$Activity);
    levels(result$Activity) <- activities$Name;
    
    result
  }

  # Main function entry
  {
    data.Load(path)
  }
}

# Aggregated representation of UCI HAR Dataset:
# data is aggregated by Subject and Activity features 
# using mean function
uci.har.aggregate <- function(path=NULL) {
  data <- uci.har.tide(path);

  result <- aggregate(data[3:length(names(data))], by = list(data$Subject, data$Activity), FUN = mean)
  names(result) <- names(data)

  result
}
