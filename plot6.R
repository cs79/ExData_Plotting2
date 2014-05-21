## This script will generate a plot of PM2.5 emissions from motor vehicle
## sources in Baltimore, MD and Los Angeles, CA in the years 1999, 2002, 2005, 
## and 2008.

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

## get Baltimore and LA subsets (fips == "24510" and "06037", respectively)
baltLA <- nei[nei$fips %in% c("24510", "06037"),]

## get motor vehicle sources, subset the Baltimore and LA data on those, 
## aggregate yearly totals
mv <- grep(".* on-road *.", levels(scc$EI.Sector), ignore.case=T, value=T)
mvSCC <- unique(scc[scc$EI.Sector %in% mv,]$SCC)
baltLAmv <- baltLA[baltLA$SCC %in% mvSCC,]
baltLAmvbyYear <- aggregate(baltLAmv$Emissions, 
                           by=list(Year=baltLAmv$year, fips=baltLAmv$fips), 
                           FUN=sum)
baltLAmvbyYear$fips <- rep(c("Los Angeles, CA", "Baltimore, MD"), each=4)

## open graphics device - dimensions are different than default for clarity
png(file = "plot6.png", width = 600, height = 400, units = "px")

## plot
library(ggplot2)
qplot(data=baltLAmvbyYear, Year, x, facets = .~fips, 
      main="Motor Vehicle Total PM2.5 Emission Trends by City", 
      xlab="Year", ylab="Total MV Emissions (tons)")

## close graphics device
dev.off()
