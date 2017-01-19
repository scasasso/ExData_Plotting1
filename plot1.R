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

# Initialize graphics device
png(file = "plot1.png",width = 480, height = 480, units = "px")

# Make plot
hist(df$Global_active_power,col = "red",xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# Close graphics device
dev.off()





