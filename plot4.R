##Greetings there! This is a R script called plot4.R
##Created by Seven_Watch
##This R script assumes you have downloaded the data file and unzipped it
##in your working directory. 

##We obtained a text document named "household_power_consumption.txt". 
##DO NOT RENAME THE FILE!

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


###PLOT 4: 
##This code creates and saves the graph as a png file in our working directory.
png("plot4.png", width=480, height=480)
par(mfrow= c(2, 2), mar = c(4, 4, 2, 1), oma= c(0, 0, 0, 0))

##plot1
plot(data$DateTimeProper, as.numeric(data$Global_active_power), type= "l", xlab = "",
     ylab = "Global Active Power")
##plot2
plot(data$DateTimeProper, as.numeric(data$Voltage), type= "l", xlab = "datetime", 
     ylab = "Voltage",ylim=c(234, 246))
##plot3
plot(data$DateTimeProper, data$Sub_metering_1, type = "l", xlab = "", ylab ="Energy sub metering")  
lines(data$DateTimeProper, data$Sub_metering_2, type = "l", col = "red", xaxt="n", yaxt="n")
lines(data$DateTimeProper, data$Sub_metering_3, type = "l", col = "blue", xaxt="n", yaxt="n")
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lty=c(1,1), cex=.70, 
       lwd=c(2.5,2.5),col=c("black", "red", "blue"), bty = "n") 
##plot4
plot(data$DateTimeProper, as.numeric(data$Global_reactive_power), type= "l", xlab = "datetime",
     ylab = "Global_reactive_power",ylim=c(0.0, 0.5))
dev.off()

##IMPORTANT NOTE:
##making the datetime an asPOSIXct object tells R to plot the x axis as "Thu"
##"Fri" and "Sat" by default, therefore removing the need to use parameters "at"
##and "labels" in the "axis" subfunction."