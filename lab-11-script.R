# load packages ----
library(log4r)
library(TeachingDemos)
library(tidyverse)
library(pracma)
library(ggmosaic)
library(stringr)
# load any additional packages here...

##I COULD NOT GET THIS TO RUN IN R MARKDOWN, SO HERE IS THE ASSIGNMENT AS AN R SCRIPT


# source function files ----
# not sure why we need these. I am not even sure what most of them do. 
# Presentation file incomplete, and did not go over how to create a new project and store downloaded data in original data folder using the barracudar functions.
source("barracudar/DataTableTemplate.R")
source("barracudar/AddFolder.R")
source("barracudar/BuildFunction.R")
source("barracudar/MetaDataTemplate.R")
source("barracudar/CreatePaddedLabel.R")
source("barracudar/InitiateSeed.R")
source("barracudar/SetUpLog.R")
source("barracudar/SourceBatch.R")

setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/")
setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird") #this doesn't seem to work.
list.files() ###this is currently listing files in the parent directory (not the one set above)
##I don't understand why, but I ran the same code in the console, and it gave me what I wanted, so I continued

#list of all files
filelist <- list.files()
filelist

filenames <- c()
#list of files of interest
for(i in 1:9){
  setwd(paste0("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird", "/", filelist[i]))
  filenames[i]<- list.files(pattern = "countdata")
  setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird/")
}
filenames

# cleaning data ----

setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird/")

#1) Cleaning the data for any empty/missing cases
for(i in 1:9){
  setwd(paste0("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird", "/", filelist[i]))
  tempdf <- read.csv(filenames[i])
  tc <- tempdf %>% drop_na(observerDistance) ##there are entire columns with NA values, so we have to do a work around and just get rid of the NAs in this column. This took time.
  write.csv(tc, filenames[i])
  setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird/")
  }

#2) Extract the year from each file name ----

vec <- NULL
#NEON.D01.BART.DP1.10003.001.brd_countdata.2022-06.expanded.20231229T053256Z.csv
for(i in 1:9){ 
  year <- str_extract(filenames[i], pattern = "(?<=countdata.).*(?=-0)") 
  vec[i] <- year 
  }

vec

#3) Calculate Abundance for each year (Total number of individuals found) ----
abundance <- data.frame(matrix(ncol = 3, nrow = 9))
colnames(abundance) <- c("Year", "Abundance", "Richness")
abundance$Year <- vec

for(i in 1:9){
  setwd(paste0("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird", "/", filelist[i]))
  tempdf <- read.csv(filenames[i])
  abundance[i,2] <- sum(tempdf$clusterSize)
  setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird/")
}

abundance
# 4) Calculate Species Richness for each year(Number of unique species found) ----


for(i in 1:9) {
  setwd(paste0("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird", "/", filelist[i]))
  tempdf <- read.csv(filenames[i])
  abundance[i,3] <- length(unique(tempdf$taxonID)) #counting the number of unique species
setwd("C:/Users/alste/Desktop/CompBio_hw_11/hw-11/NEON_count-landbird/")
}

abundance
