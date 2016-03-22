
# Read data from the folder

y_test <- read.table("test/y_test.txt", col.names="label") 
subject_test <- read.table("test/subject_test.txt", col.names="subject") 
X_test <- read.table("test/X_test.txt") 

y_train <- read.table("train/y_train.txt", col.names="label") 
subject_train <- read.table("train/subject_train.txt", col.names="subject") 
X_train <- read.table("train/X_train.txt") 
 
#1.Merges the training and the test sets to create one data set

data <- rbind(cbind(subject_test, y_test, X_test), 
               cbind(subject_train, y_train, X_train)) 
 

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 

# read the features 
  features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE) 
  # only retain features of mean and standard deviation 
 feamesd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ] 
 

 # select only the means and standard deviations from data 
 # increment by 2 because data has subjects and labels in the beginning 
 datameds <- data[, c(1, 2, feamesd$V1+2)] 
 

# 3.Uses descriptive activity names to name the activities in the data set
 labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE) 
 datameds$label <- labels[datameds$label, 2] 

#4.Appropriately labels the data set with descriptive variable names
appronames <- c("subject", "label", feamesd$V2) 
appronames <- tolower(gsub("[^[:alpha:]]", "", appronames)) 
colnames(datameds) <- appronames 
 

 ## step 5 
 # find the mean for each combination of subject and label 
 aggdata <- aggregate(datameds[, 3:ncol(datameds)], 
                by=list(subject = datameds$subject,label = datameds$label),mean) 
 

 ## step nothing 
 # write the data for course upload 
 write.table(format(aggdata, scientific=T), "tidy2.txt", 
           row.names=F, col.names=F, quote=2) 
