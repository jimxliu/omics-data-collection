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

# param: fname
# return: file type: diff, norm, fpkm, rpkm, raw
getFileType<- function(fname){
   if(!grepl("_raw\\.tar$", fname, ignore.case = TRUE, perl = TRUE)) {
      # Patterns
      normalized <- "(?=.*normalized)"
      raw <- "(?=.*raw)(?=.*count)"
      fpkm <- "fpkm"
      rpkm <- "rpkm"
      diff <- "edgeR|cuffdiff|diff"
      count <- "count"
      
      if(grepl(diff, fname, ignore.case = TRUE, perl = TRUE) )
      {
         return("diff")
      }
      else if(grepl(normalized, fname, ignore.case = TRUE, perl = TRUE) 
         && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE)) 
      {  # normalized counts
         return("norm")
      } 
      
      else if(grepl(fpkm, fname, ignore.case = TRUE, perl = TRUE) 
              && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE))
      {  
         # print(paste(fname, "fpkm")) 
         return("fpkm")
      }
      
      else if(grepl(rpkm, fname, ignore.case = TRUE, perl = TRUE) 
              && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE))
      {
         # print(paste(fname, "rpkm")) 
         return("rpkm")
      } 
      
      else if(grepl(raw, fname, ignore.case = TRUE, perl = TRUE) 
              || grepl(count, fname, ignore.case = TRUE, perl = TRUE)) 
         
      {  
         # raw counts 
         return("raw")
      }
   } 
   return()
}


getFileType("GSE12312_RAW.tar")

getFileType("GSE67722_minus1-diff.txt.gz")





