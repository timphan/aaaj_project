library(acs)
api.key.install(key="7fb29c043363cb73a01e497f3075b73622304929")
library(ggplot2)
library(ggmap)
library(dplyr)
library(rgdal)
library(RColorBrewer)
library(scales)
library(Cairo)
library(stringr)

laoc<- geo.make(state="CA", county=c("Los Angeles", "Orange"), tract="*")
hey<- acs.fetch(endyear = 2012, span = 5, geo = laoc, table.number = "C27001D", col.names = "pretty")
sad<- hey[, str_count(hey@acs.colnames, "No health insurance coverage") > 0]
coverage.county.total <- apply(sad, 2, sum)
coverage.rate <- divide.acs(numerator = coverage.county.total, denominator = hey[, 1], method = "proportion")
coverage.est <- data.frame(
  county = geography(coverage.rate)[[1]],
  rate = as.numeric(estimate(coverage.rate)),
  healthpop = as.numeric(estimate(hey[, 1]))
)


tract<- hey@geography
coverage.est$tract<- tract$tract
colnames(coverage.est)<- c("county","percent","pop","id")

la<- filter(coverage.est, grepl("Angeles",county))
oc<- filter(coverage.est, !grepl("Angeles",county))
la$id <- paste("1400000US06037", la$id, sep = "")
oc$id <- paste("1400000US06059", oc$id, sep = "")
ocla<- rbind(la,oc)

state <- readOGR(dsn = ".", layer = "gz_2010_06_140_00_500k")
state <- fortify(state, region="GEO_ID")
lotData <- left_join(state, ocla)



map <- get_map("Los Angeles", zoom = 9, maptype = "roadmap")
p <- ggmap(map)
p<- ggmap(map) +
  geom_polygon(data = lotData, aes(x = long, y = lat, group = group,
                                fill = percent), colour = NA, alpha = 0.5) +
  scale_fill_distiller(palette = "YlOrRd", breaks = pretty_breaks(n = 10),
                       labels = percent) +
  labs(fill = "") +
  theme_nothing(legend = TRUE) +
  guides(fill = guide_legend(reverse = TRUE, override.aes =
                               list(alpha = 1)))
