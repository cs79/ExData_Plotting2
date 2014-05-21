## This script will generate a plot of PM2.5 emissions from coal combustion-
## related sources across the US in the years 1999, 2002, 2005, and 2008.

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

## find the subset of coal combustion-related sources and aggregate yearly total
coalComb <- grep("comb .* coal", levels(scc$EI.Sector), ignore.case=T, value=T)
coalCombSCC <- unique(scc[scc$EI.Sector %in% coalComb,]$SCC)
neiCoal <- nei[nei$SCC %in% coalCombSCC,]
coalEmByYear <- aggregate(neiCoal$Emissions, by=list(Year = neiCoal$year), 
                          FUN=sum)

## open graphics device
png(file = "plot4.png", width = 480, height = 480, units = "px")

## plot
plot(coalEmByYear$Year, coalEmByYear$x, pch=19, 
     main="Total Yearly PM2.5 Emissions: Coal Combustion Sources", xlab="Year", 
     ylab="Total Coal Emissions (tons)", xlim=c(1998, 2010))
abline(lm(coalEmByYear$x ~ coalEmByYear$Year))
text(coalEmByYear$Year + 0.5, coalEmByYear$x, 
     labels=c("1999", "2002", "2005", "2008"))

## close graphics device
dev.off()
