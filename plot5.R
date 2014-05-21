## This script will generate a plot of PM2.5 emissions from motor vehicle
## sources in Baltimore, MD in the years 1999, 2002, 2005, and 2008.

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

## get Baltimore subset
balt <- nei[nei$fips=="24510",]

## get motor vehicle sources, subset the Baltimore data on those, aggregate
## yearly totals
mv <- grep(".* on-road *.", levels(scc$EI.Sector), ignore.case=T, value=T)
mvSCC <- unique(scc[scc$EI.Sector %in% mv,]$SCC)
baltMV <- balt[balt$SCC %in% mvSCC,]
baltMVByYear <- aggregate(baltMV$Emissions, by=list(Year=baltMV$year), FUN=sum)


## open graphics device
png(file = "plot5.png", width = 480, height = 480, units = "px")

## plot
plot(baltMVByYear$Year, baltMVByYear$x, pch=19, 
     main="Total Yearly PM2.5 Emissions: Motor Vehicles in Baltimore, MD",
     xlab="Year", ylab="Total MV Emissions (tons)", xlim=c(1998, 2010))
abline(lm(baltMVByYear$x ~ baltMVByYear$Year))
text(baltMVByYear$Year + 0.5, baltMVByYear$x, 
     labels=c("1999", "2002", "2005", "2008"))

## close graphics device
dev.off()
