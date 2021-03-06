##Greetings there! This is a R script called plot1.R
##Created by Seven_Watch
##This R script assumes you have downloaded the data file and unzipped it
##in your working directory. 

##We obtained a text document named "household_power_consumption.txt". 
##Do not rename the file!

##Now we have to read our data.
##This is the path to the txt document
x <- "./household_power_consumption.txt"

##It is a very large data file. But we can read it fast with the fread function
##in the data.table package.

##This part of the code checks if the package is already installed and if not 
##it installs it.
if (!require("pacman")) install.packages("pacman")
pacman::p_load("data.table")
library("data.table") ##loading the package
##Reading the data

data <- fread(x, na.strings="?")
##We have read the file and have assigned the ? as NA.

##We need to perform lots of transformations but the file is too big. 
##This is my workaround to subset into a smaller and easier to handle data
##this data. I couldn't figure out another way.
data$Date2 <- as.Date( as.character(data$Date), "%d/%m/%Y")
data <- subset(data, as.Date(data$Date2) == "2007-02-01" |as.Date(data$Date2) == "2007-02-02")
data <- na.omit(data) ##Cleaning the data from NA.

##We have to transform the Date and Time variable into a single variable 
##with a date and time class.
data$DateTime <- paste(data$Date, data$Time) ##First we paste the data
data$DateTimeProper <- as.POSIXct(data$DateTime, format ="%d/%m/%Y %H:%M:%S")
##Now we create the new variable with the correct class


###PLOT 1: Histogram Global Active power
##This code creates and saves the graph as a png file in our working directory.
png(filename= "plot1.png", width=480, height=480)
hist(as.numeric(data$Global_active_power), col= "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)",ylim=c(0, 1200))
dev.off()
