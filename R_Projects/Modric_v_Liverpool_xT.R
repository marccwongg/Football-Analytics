library(StatsBombR)
library(plyr)
library(dplyr)
library(ggshakeR)

comp <- FreeCompetitions() %>%
  filter(competition_id == 16 & season_name == "2017/2018")

Matches <- FreeMatches(comp)

StatsBombData <- StatsBombFreeEvents(MatchesDF = Matches, Parallel = TRUE)

StatsBombData <- allclean(StatsBombData)

plottingData <- StatsBombData
plottingData <- plottingData %>%
  rename("x" = "location.x",
         "y" = "location.y",
         "finalX" = "pass.end_location.x",
         "finalY" = "pass.end_location.y")
xTData <- calculate_threat(plottingData, dataType = "statsbomb")

plotcarryData <- StatsBombData
plotcarryData <- plotcarryData %>%
  rename("x" = "location.x",
         "y" = "location.y",
         "finalX" = "carry.end_location.x",
         "finalY" = "carry.end_location.y")
xT_CarryData <- calculate_threat(plotcarryData, dataType = "statsbomb")

xTData$xTStart[is.na(xTData$xTStart)] <- xT_CarryData$xTStart[match(xTData$id,xT_CarryData$id)][which(is.na(xTData$xTStart))]

xTData$xTEnd[is.na(xTData$xTEnd)] <- xT_CarryData$xTEnd[match(xTData$id,xT_CarryData$id)][which(is.na(xTData$xTEnd))]

xTData <- xTData %>%
  mutate(xT = xTEnd - xTStart)

Modric_xTData <- xTData[xTData$player.id == 5463,]

colSums(Modric_xTData[ , 161], na.rm=TRUE)
