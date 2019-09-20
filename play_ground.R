library(rentrez)

source("./util.R")

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

showAllFileFormats(recsum)

rs <- recsum$`200128434`
isMultiTaxon(rs)

