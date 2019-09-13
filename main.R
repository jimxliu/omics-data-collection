
if(!requireNamespace("BiocManager", quitely = TRUE)){ 
   install.packages("BiocManager")
}

if(!library(GEOquery, logical.return = TRUE, quietly = TRUE)) {
   BiocManager::install("GEOquery")
}

if(!requireNamespace("rentrez", quietly = TRUE)){
   install.packages("rentrez")
}

if(!requireNamespace("hash", quietly = TRUE)) {
   install.packages("hash")
}

if(!requireNamespace("stringr", quietly = TRUE)) {
   install.packages("stringr")
}

library(rentrez)
library(GEOquery)
library(hash)
library(stringr)

source("./isSingleCell.R")
source("./getGenomeVersion.R")
source("./getPMID.R")
source("./downloadValidFiles.R")


# Make a query
organism <- "Zea mays [Organism]"
datatype <- "expression profiling by high throughput sequencing [DataSet Type]"
suppfiles <- "(CSV [Supplementary Files])"
query <- paste(c(organism, datatype, suppfiles), collapse = " AND ")

# Search the first time to get number of GSE records
res <- entrez_search(db='gds', term=query, use_history=TRUE)

# Search the second time set the max number of records to res$count 
res <- entrez_search(db='gds', term=query ,retmax=res$count, use_history=TRUE)

# Summary of returned records.
recsum <- entrez_summary(db='gds', id=res$ids)

# Extract the accession id and list of samples (GSM) of each GSE
gse_list <- extract_from_esummary(recsum, c('gse'))


for(num in gse_list[7:7]){
   gse <- paste0("GSE",num)
   
   eList <- getGEO(gse)
   eData <- eList[[1]]
   pd <- pData(eData)
   # dname <- paste0("./data/",gse)
   # dir.create(dname, recursive = TRUE)
   
   version <- getGenomeVersion(pd) 
   if(is.na(version)) {
      next
   }
   if(isSingleCell(pd)){
      next
   }
   downloadValidFiles(gse)
}

