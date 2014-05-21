## This script will generate a plot of total PM2.5 emissions from all sources in 
## the EPA NEI dataset for each of the years 1999, 2002, 2005, and 2008 in base.


## download the data
if(!file.exists("./data")) {dir.create("./data")}
zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#Windows:
download.file(zipURL, destfile="./data/NEIdata.zip")
#Mac:
download.file(zipURL, destfile="./data/NEIdata.zip", method="curl")
dateDownloaded <- date()

## unzip
unzip("./data/NEIdata.zip", exdir="./data")

## load into R
nei <- readRDS("./data/summarySCC_PM25.rds")
scc <- readRDS("./data/Source_Classification_Code.rds")

## get totals by year
totals <- aggregate(nei$Emissions, by=list(Year = nei$year), FUN=sum)

## open graphics device
png(file = "plot1.png", width = 480, height = 480, units = "px")

## plot
plot(totals$Year, totals$x, pch=19, main="Total PM2.5 Emissions per Year", 
     xlab="Year", ylab="Total Emissions (tons)", xlim=c(1998, 2010))
abline(lm(totals$x ~ totals$Year))
text(totals$Year + 0.5, totals$x, labels=c("1999", "2002", "2005", "2008"))

## close graphics device
dev.off()
