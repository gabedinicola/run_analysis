library(data.table)

## read files into r and assign them to corresponding values- prepare for merging data sets
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")

## features_new is the original fetaures taking only mean and standard deviation into account
features_new <- grep(".*mean.*|.*std.*", features[,2])
features_new.names <- features[features_new,2]
features_new.names = gsub('-mean', 'Mean', features_new.names)
features_new.names = gsub('-std', 'Std', features_new.names)
features_new.names <- gsub('[-()]', '', features_new.names)

## read files into r and assign them to corresponding values- prepare for merging data sets

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)[features_new]
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)[features_new]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
y_test$V1 <- factor(y_test$V1,levels=activity_labels$V1,labels=activity_labels$V2)
y_train$V1 <- factor(y_train$V1,levels=activity_labels$V1,labels=activity_labels$V2)

x_train<-cbind(subject_train,y_train,x_train)
x_test<-cbind(subject_test,y_test,x_test)
 
## merge data sets
final_merge<-rbind(x_train, x_test)
colnames(final_merge)<-c("subject", "activity", features_new.names)

# create mean version of final_merge data set
final_merge_mean<-sapply(final_merge,mean,na.rm=TRUE)

# creates final tidy data set with the average of each variable for each activity and each subject
DT <- data.table(final_merge)
tidy_data<-DT[,lapply(mean),by="activity,subject"]
write.table(tidy_data, "tidy_data.txt",row.name=FALSE)
