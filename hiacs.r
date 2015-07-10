library(acs)
library(stringr)


acs.lookup(endyear=2012, span=3,dataset="acs", keyword ="HEALTH INSURANCE", case.sensitive=F)
acs.lookup(endyear=2012, span=3,dataset="acs", table.name="HEALTH INSURANCE COVERAGE STATUS BY AGE (ASIAN ALONE)", case.sensitive=F)
ad <- c("C27001D_004", "C27001D_007", "C27001D_010")

la<- geo.make(state="CA", county="Los Angeles", tract="*")
hi<- acs.fetch(endyear = 2012, span = 5, geo = la, table.number = "C27001D", col.names = "pretty")
sad<- hi[, str_count(hi@acs.colnames, "No health insurance coverage") > 0]
coverage.county.total <- apply(sad, 2, sum)
coverage.rate <- divide.acs(numerator = coverage.county.total, denominator = hi[, 1], method = "proportion")
coverage.est <- data.frame(
  county = geography(coverage.rate)[[1]],
  rate = as.numeric(estimate(coverage.rate)),
  healthpop = as.numeric(estimate(hi[, 1]))
)


tract<- hey@geography
coverage.est$tract<- tract$tract
colnames(coverage.est)<- c("county","percent","pop","id")
coverage.est$id <- paste("1400000US06037", coverage.est$id, sep = "")
state <- readOGR(dsn = ".", layer = "gz_2010_06_140_00_500k")
state <- fortify(state, region="GEO_ID")
plotData <- left_join(state, coverage.est)