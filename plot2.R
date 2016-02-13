# R-script to execute the Week 1 project for Exploratory Data Analysis
# Written by Mark Bulkeley 2016-02-13
library(data.table)

# estimate the size of the data set coming in, based on information provided 
rows <- 2075259
columns <- 9
estimated_data_size <- rows * columns * 8 / 1024 / 1024     # assumes all columns are floats (8 bytes), converts into MB

# open the data file
dt.data <- data.table(read.csv('/Volumes/MacStorage/Coursera Data/household_power_consumption.txt', 
                               header = TRUE, sep = ';', na.strings = c("?", "NA")))
# calculate actual memory usage, less than the predicted
as.numeric(object.size(x = dt.data)) / 1024 / 1024

# subset data to just days that we are looking for (save time on future processing): "We will only be using data from the dates 2007-02-01 and 2007-02-02"
vec.days <- c('1/2/2007', '2/2/2007')   # vec.days <- c('1/2/2007', '2/2/2007')
dt.days <- dt.data[Date %in% vec.days]

# make date information useful, by adding a leading '0' on the day and month; data was not in the format claimed (i.e., it was d/m/yyyy not dd/mm/yyyy)
dt.days[, Date := gsub("^([1-9]{1})/", "0\\1/", Date, perl = TRUE)]
dt.days[, Date := gsub("/([1-9]{1}/)", "/0\\1", Date, perl = TRUE)]
dt.days[, Date_Time := paste(Date, Time)]
dt.days[, date_time := as.character(strptime(dt.days$Date_Time, format = "%d/%m/%Y %H:%M:%S"))]

# Open graphics device and set size
png(filename = "/Volumes/MacStorage/Git/ExData_Plotting1/plot2.png", 
    width = 480, height = 480)

# Plot 2: Time Series of Global Active Power
with(dt.days[!is.na(Global_active_power)], {
  plot(as.POSIXlt(date_time), Global_active_power,
       ylab = "Global Active Power (kilowatts)", 
       xlab = NA, pch = NA)
  lines(as.POSIXlt(date_time), Global_active_power)
})

# Close graphics device
dev.off()