library(GEOquery)

eList <- getGEO("GSE111250")
class(eList)
length(eList)
names(eList)
eData <- eList[[1]]
eData

pd <- pData(eData)
names(pd)
pd$data_processing.5

eList2 <- getGEO("GSE98379")
class(eList2)
length(eList2)
names(eList2)
eData2 <- eList2[[1]]
eData2

pd2 <- pData(eData2)

pd2["data_processing.6"]

