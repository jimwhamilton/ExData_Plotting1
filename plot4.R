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

.pardefault <- par(no.readonly = T)

## Plot 1

## Plot histogram of Global_active_power for those 2 days
## set colour of bars to "red"
## set title with "main"
## set x-axis label with "xlab"

hist(dt[, Global_active_power], col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

## write plot to .png file in current working directory, close png device afterwards
dev.copy(png,"plot1.png", height=480, width=480)
dev.off()



## Plot 2

## Scatter plot of type "l" = line
## Change y-axis label to match. Blank x-label

plot(dt[, DateTime], dt[, Global_active_power], ylab="Global Active Power (kilowatts)", xlab="", type="l")

## write plot to .png file in current working directory, close png device afterwards
## height and width is 480x480 as required
dev.copy(png,"plot2.png", height=480, width=480)
dev.off()


## Plot 3

## 3 Line "scatter" plots for all the sub_metering groups
## Legend added to top right with correct colours set for each line. "lwd" adds line (at width=1) to legend.


plot(dt[, DateTime],
     dt[, Sub_metering_1],
     ylab = "Energy sub metering",
     xlab = "",
     type = "l")
lines(dt[, DateTime], dt[, Sub_metering_2], col = "red")
lines(dt[, DateTime], dt[, Sub_metering_3], col = "blue")


## text.width = 450000 means that legend box is bigger than default when converting to .png.
## defaults cause the truncation of text within
legend( "topright",
        col = c("black", "red", "blue"),
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lwd = 1,
        text.width = c(45000)
)

## write plot to .png file in current working directory, close png device afterwards
dev.copy(png,"plot3.png", height=480, width=480)
dev.off()




## Plot 4
## 4 plots in one pane

## set mfcol to 2,2 so 2 rows and 2 columns
## mfcol instead of mfrow means first 2 plots plot in column 1 (top then bottom) and these are pretty much same as
## plot 2 and plot 3 above
par(mfcol=c(2,2))

## top-left plot - same as plot 2 above but slightly shortened y-axis label
plot(dt[, DateTime], dt[, Global_active_power], ylab="Global Active Power", xlab="", type="l")

## bottom-left plot (almost the same as plot 3 above)
## but added 'bty="n"' to make box around legend disappear
## and modified text.width for png conversion
plot(dt[, DateTime], dt[, Sub_metering_1], ylab="Energy sub metering", xlab="", type="l")
lines(dt[, DateTime], dt[, Sub_metering_2], col="red")
lines(dt[, DateTime], dt[, Sub_metering_3], col="blue")
legend("topright", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd=1, bty="n", text.width = c(60000))

## top right plot
## scatter, line type : datetime vs. voltage
plot(dt[, DateTime], dt[, Voltage], ylab="Voltage", xlab="datetime", type="l")


## bottom right plot
## scatter, line type : datetime vs. global reactive power
plot(dt[, DateTime], dt[, Global_reactive_power], ylab="Global_reactive_power", xlab="datetime", type="l")

dev.copy(png,"plot4.png", height=480, width=480)
dev.off()
