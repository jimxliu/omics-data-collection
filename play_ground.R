library(rentrez)
library(GEOquery)
source("./utilities.R")

# Make a query
organism <- "Zea mays [Organism]"
datatype <- "expression profiling by high throughput sequencing [DataSet Type]"
suppfiles <- "(CSV [Supplementary Files])"
query <- paste(c(organism, datatype), collapse = " AND ")

# Search the first time to get number of GSE records
res <- entrez_search(db='gds', term=query, use_history=TRUE)

# Search the second time set the max number of records to res$count 
res <- entrez_search(db='gds', term=query ,retmax=res$count, use_history=TRUE)

# Summary of returned records.
recsum <- entrez_summary(db='gds', id=res$ids)




invalid <- getFileType("GSE12312_RAW.tar")


getFileType("GSE67722_minus1-diff.txt.gz")


myList <- c("a")
c(myList, "b")

dates <- strsplit("2019/01/01-2019/12/31", "-")
dates[[1]][2]

# eList <- getGEO("GSE64665")
# eList <- getGEO("GSE128434")
# eList <- getGEO("GSE138028")
# eList <- getGEO("GSE136433")
eList <- getGEO("GSE128395")

eList <- tryCatch({ 
   getGEO("GSE138028")
}, error = function(e) {
   print("Cannot fetch data, SKIP!")
   return()
})
eList
is.null(eList)


length(eList)

eData <- eList[[1]]
pd <- pData(eData)
pd$organism_ch1[[1]] == "Arabidopsis thaliana" 

if(any(grepl("supplementary_file", names(pd), perl = TRUE, ignore.case = TRUE))){
   print("it has supp")
}

if(TRUE){
   xyz <- 1
}
xyz

gse <- "GSE138028"
eList <- tryCatch({ 
   getGEO(gse)
}, error = function(e) {
   print("Cannot fetch data, SKIP!")
   NULL
})

eList

files <- getValidFiles(gse = "GSE136433", organism = "Homo sapiens")

files <-  getGEOSuppFiles("GSE109281", fetch_files = FALSE)
files
rows <- c(5)
length(rows)
df <- files[-rows,]
df
files