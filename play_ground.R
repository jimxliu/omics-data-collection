library(GEOquery)

eList <- getGEO("GSE111250")
class(eList)
length(eList)
names(eList)
eData <- eList[[1]]
eData

pd <- pData(eData)
names(pd)
pd$library_strategy

nlevels(pd$extract_protocol_ch1.2)
pd$extract_protocol_ch1.2




eList2 <- getGEO("GSE121039")
class(eList2)
length(eList2)
names(eList2)
eData2 <- eList2[[1]]
eData2

pd2 <- pData(eData2)

names(pd2)
pd2["GSM3424967","contact_city"]

exit <- FALSE
for(col in colnames(pd2)){
   for(row in rownames(pd2)) {
      if(any(grepl("celseq", pd2[row, col], ignore.case = TRUE, perl = TRUE))) {
         print(col)
         exit <- TRUE
         break
      }
   }
   if(exit) break
}

pd2$extract_protocol_ch1.1

gsm <- getGEo("GSM3424967")

