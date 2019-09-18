library(GEOquery)

# check how many GSEs have supplementary files downloadable

# Make a query
organism <- "Zea mays [Organism]"
datatype <- "expression profiling by high throughput sequencing [DataSet Type]"
suppfiles <- ""
query <- paste(c(organism, datatype, suppfiles), collapse = " AND ")

query

# Search the first time to get number of GSE records
res <- entrez_search(db='gds', term=query, use_history=TRUE)

# Search the second time set the max number of records to res$count 
res <- entrez_search(db='gds', term=query ,retmax=res$count, use_history=TRUE)

paste("Returned", res$count, "results.")

# Summary of returned records.
recsum <- entrez_summary(db='gds', id=res$ids)

# Extract the accession id and list of samples (GSM) of each GSE
gse_list <- extract_from_esummary(recsum, c('gse'))

count <- 0
for(num in gse_list){
   gse <- paste0("GSE", num)
   files <-  getGEOSuppFiles(gse, fetch_files = FALSE)
   if(!is.null(files) && nrow(files) > 0) {
      count <- count + 1
   }
}


sprintf("%d out of %d GSE records have attached supplementary files", count, res$count)
# "149 out of 153 GSE records have attached supplementary files"
> 