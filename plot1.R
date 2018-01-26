## load lubridate for time and date manipulation
library(lubridate)


## load data.table as efficient package for manipulating data
library(data.table)

## set working directory to local git clone
setwd("~/Coursera/ExData_Plotting1")


## load text file using read.table
## columns separated by ";"
## set all strings as character type
## Use first row as column headers
df <- read.table("household_power_consumption.txt", sep=";", header=T, stringsAsFactors = F)

## convert loaded data frame to data table
dt <- as.data.table(df)


## change any "?" values for every column - missing values - to NA
for (var in names(dt)) {
        dt[(var) == "?", (var) == NA]
}

dt[, DateTime := paste(Date, Time)]
dt[, DateTime := strptime(DateTime, format="%d/%m/%Y %H:%M:%S")]




## Create list of variable to convert from character to numeric
numericvars <- setdiff(names(dt), c("Date", "Time", "DateTime"))

## Convert these variables to numeric type
for (var in numericvars) {
        dt[, (var) := as.numeric(get(var))]
        
        
}

## Restrict date to 2 days specified in instructions
dt <- dt[DateTime >= "2007-02-01" & DateTime < "2007-02-03"]


## Plot 1

## Plot histogram of Global_active_power for those 2 days
## set colour of bars to "red"
## set title with "main"
## set x-axis label with "xlab"

hist(dt[, Global_active_power], col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

## write plot to .png file in current working directory, close png device afterwards
dev.copy(png,"plot1.png", height=480, width=480)
dev.off()
