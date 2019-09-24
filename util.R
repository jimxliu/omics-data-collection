library(rentrez)
library(GEOquery)
library(hash)

showAllFileFormats <- function(recsums) {
   supp_format_list <- extract_from_esummary(recsums, c('suppfile'))
   
   supp_format_list
   
   format_set <- hash()
   
   for(formats in strsplit(supp_format_list, ", ")){
      for(f in formats){
         if(!has.key(f, format_set)){
            format_set[f] <- 1
         } else {
            format_set[f] <- format_set[[f]] + 1
         }
      }
   }
   
   for(key in keys(format_set)){
      print(sprintf("%s: %d", key, format_set[[key]]))
   }
}

isMultiTaxon <- function(recsum){
   mylist <- strsplit(recsum$taxon, "; ")
   return (length(unlist(mylist)) > 1)
}



getHTSeqSummmaryByOrganism <- function(organism){
   dataset_type <- "expression profiling by high throughput sequencing"
   return(getSummary(organism, dataset_type))
}



getSummary <- function(organism, dataset_type, suppfile_type = "") {
   organism <- paste(organism, "[Organism]")
   dataset_type <- paste(dataset_type, "[DataSet Type]")
   if(suppfile_type != ""){
      suppfile_type <- paste(suppfile_type, "[Supplementary Files]")
   }
   # Form query
   query <- paste(c(organism, dataset_type, suppfile_type), collapse = " AND ")
   
   # Search the first time to get number of GSE records
   res <- entrez_search(db='gds', term=query, use_history=TRUE)
   
   # Search the second time set the max number of records to res$count 
   res <- entrez_search(db='gds', term=query ,retmax=res$count, use_history=TRUE)

   # Summary of returned records.
   recsum <- entrez_summary(db='gds', id=res$ids)

   return(recsum)
}