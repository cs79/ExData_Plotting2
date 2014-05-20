## This script will generate a plot of PM2.5 emissions by type in Baltimore, MD 
## for the years 1999, 2002, 2005, and 2008, using ggplot2.

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

## get subset of Baltimore data (fips == "24510") and aggregate by year and type
balt <- nei[nei$fips=="24510",])
sumByYearType <- aggregate(balt$Emissions, 
                           by=list(Year=balt$year, Type=balt$type), FUN=sum)

## open graphics device - dimensions are larger than default for clarity
png(file = "plot3.png", width = 800, height = 400, units = "px")

## plot with facet on source ?  this doesn't quite work, because i'd rather see 
## totals by type
library(ggplot2)
qplot(data=sumByYearType, Year, x, facets = .~Type, 
      main="Baltimore, MD Total Emission Trends by Source Type", xlab="Year")

## close graphics device
dev.off()
