hasSql <- TRUE
if (!require(sqldf)) hasSql <- FALSE

# Check if dataset is already present in the directory
filePath <- "./data/household_power_consumption.txt"
if (!file.exists(filePath)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    if (!dir.exists("./data")) dir.create("./data")
    download.file(url = fileUrl, destfile = "./data/dataset.zip", method = "curl")
    unzip(zipfile = "./data/dataset.zip", exdir = "./data")
}

# Get the data.frame
# Subset in order to get only the data from the 2 days we are interested in
df <- 0
if (hasSql == TRUE) { #faster
    df <- read.csv.sql(filePath,sql = "select * from file where Date == '1/2/2007' or Date == '2/2/2007' ",sep = ";")
    # Replace ? with NAs (cannot use na.strings argument in read.csv.sql...)
    df[df == "?"] <- NA
} else { 
    df <- read.csv(filePath,sep = ";",na.strings = c("?"))
    df <- df[df$Date == "1/2/2007" | df$Date == "2/2/2007",]
}

# Add "datetime" variable
df$dateTime <- strptime(paste(df$Date,df$Time),"%e/%m/%Y %H:%M:%S")

# Initialize graphics device
png(file = "plot3.png",width = 480, height = 480, units = "px")

# Make plot
with(df,plot(dateTime,Sub_metering_1,type="l",col="black",xlab = "",ylab = "Energy sub metering"))
with(df,points(dateTime,Sub_metering_2,type="l",col="red"))
with(df,points(dateTime,Sub_metering_3,type="l",col="blue"))
legend("topright",lty = c(1,1,1),col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# Close graphics device
dev.off()





