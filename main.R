
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

library(GEOqsadfuery, logical.return = TRUE, quietly = TRUE)


library(rentrez)
library(GEOquery)
library(hash)
# library(stringr)

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


