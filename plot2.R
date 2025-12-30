library(tidyverse)
library(chron)

if(!file.exists("cleandata.csv")) {
  # Download the dataset & extract
  src <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(src, "household_power_consumption.zip", quiet = TRUE)
  unzip("household_power_consumption.zip")
  unlink("household_power_consumption.zip")
  
  # Filter the dataset immediately by date
  rawdata <- read.table("household_power_consumption.txt", header=TRUE, sep=";")
  unlink("household_power_consumption.txt")
  rawdata$Date <- as.Date(rawdata$Date, "%d/%m/%Y") 
  cleandata <- rawdata %>%
    filter(Date %in% as.Date(c("2007-02-01", "2007-02-02")))
  
  # Convert Time from string to datetime class
  cleandata$DateTime <- as.POSIXct(paste(cleandata$Date, cleandata$Time))
  
  # Save as CSV file
  write_csv(cleandata, "cleandata.csv")
}

cleandata <- read_csv("cleandata.csv", show_col_types = FALSE)

# Create the plot

with(cleandata, plot(Global_active_power~DateTime, type="l",
     ylab="Global Active Power (kilowatts)", xlab=""))

# Save plot as PNG
dev.copy(png, file="plot2.png")
dev.off()