## This script will generate a plot of total PM2.5 emissions for Baltimore, MD 
## using the EPA NEI dataset for each of the years 1999, 2002, 2005, and 2008 in
## base.

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

## get Baltimore data (subset on fips == "24510"), then aggregate totals by year
balt <- nei[nei$fips=="24510",]
baltYears <- aggregate(balt$Emissions, by=list(Year = balt$year), FUN=sum)

## open graphics device
png(file = "plot2.png", width = 480, height = 480, units = "px")

## plot
plot(baltYears$Year, baltYears$x, pch=19, 
     main="Total Yearly Emissions: Baltimore, MD Data", xlab="Year", 
     ylab="Total Emissions", xlim=c(1998, 2010))
abline(lm(baltYears$x ~ baltYears$Year))
text(baltYears$Year + 0.5, baltYears$x, 
     labels=c("1999", "2002", "2005", "2008"))

## close graphics device
dev.off()
