library(rentrez)
library(GEOquery)
library(hash)
# install.packages("stringr")
library(stringr)

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
gse_list <- extract_from_esummary(recsum, c('gse'))
gse_list
gse_list[[1]]


# Check Genome Version of each GSE (Need to consider GSEs with more than one GV)
# for(id in res$ids){
for(id in 1:1){
   gse <- paste0("GSE", gse_list[[id]])
   print(gse)
   eList <- getGEO(gse)
   eData <- eList[[1]]
   
   class(pData(eData))
   df <- pData(eData)
   
   
   for( name in names(df)){
      # print(name)
      
      if(grepl("data_processing", name, ignore.case = TRUE, perl = TRUE) &&
         any(grepl("genome_build", df[[name]], ignore.case = TRUE, perl = TRUE)))
      {
         gv_set <- hash() 
         sapply(df[[name]], function(line) 
                           if(!is.na(str_extract(line, "v[0-9]"))){
                              gv_set[str_extract(line, "v[0-9]")] <- 1
                           })

         if(length(gv_set) == 1){
            print(keys(gv_set)[[1]])
         }
         clear(gv_set)
      }
   }
   

}

