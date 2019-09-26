library(GEOquery)


# Test each GSE to see if the "extract_protocol_ch1.x" contains patterns 
# indicating using single-cell techniques, such as CelSeq, single-cell, split-cell

# Function, params: df (data.frame, GSE phenotype data)
isSingleCell <- function(pd) {
   for(col in colnames(pd)){
      if(grepl("extract_protocol", col, ignore.case = TRUE, perl = TRUE)){
         for(row in rownames(pd)) {
            if(any(grepl("celseq|split-cell|single-cell", pd[row, col], ignore.case = TRUE, perl = TRUE))) {
               return(TRUE)
            }
         }
      }
   }
   return(FALSE)
}


# # Example using Single-Cell technique
# eList2 <- getGEO("GSE121039")
# eData2 <- eList2[[1]]
# pd2 <- pData(eData2)
# 
# isSingleCell(pd2)
# 
# # Example NOT using Single-Cell technique
# eList <- getGEO("GSE111250")
# eData <- eList[[1]]
# pd <- pData(eData)
# 
# isSingleCell(pd)