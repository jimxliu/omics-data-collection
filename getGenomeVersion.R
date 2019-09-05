library(rentrez)
library(GEOquery)

# Obtain a list of all GEO series (GSE) associated with Maize and Gene expression profiling.
organism <- "Zea mays [Organism]"
datatype <- "expression profiling by high throughput sequencing [DataSet Type]"
suppfiles <- "(CSV [Supplementary Files])"

query <- paste(c(organism, datatype, suppfiles), collapse = " AND ")

res <- entrez_search(db='gds', term=query, use_history=TRUE)
res$count
# Get number of GSE records
# n_records = res$count
n_records = 20
res <- entrez_search(db='gds', term=query ,retmax=n_records, use_history=TRUE)
summary(res)

# Summary of each record by its record id.
recsum <- entrez_summary(db='gds', id=res$ids)
recsum

# Extract the accession id and list of samples (GSM) of each GSE
gse_list <- extract_from_esummary(recsum, c('samples'))
gse_list


# Check Genome Version of each GSE (Need to consider GSEs with more than one GV)
for(id in res$ids){
   gsm_acc_id <- gse_list['accession', id][[1]][1]
   gsm <- getGEO(gsm_acc_id)
   meta <- Meta(gsm)
   class(meta)
   names(meta)
   for(line in meta$data_processing){
      if(grepl("genome_build", tolower(line), perl=TRUE)) {
         print(line)
      }
   }
}


