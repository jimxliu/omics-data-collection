library(rentrez)
library(GEOquery)
library(hash)

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
gse_list <- extract_from_esummary(recsum, c('gse','suppfile'))
gse_list

gse_list["suppfile",1]


gse <- "GSE129683"
filePaths <- getGEOSuppFiles(gse, fetch_files = FALSE)
filePaths

?getGEOSuppFiles
colnames(filePaths)

getValidFiles("GSE111250")

# Function: get the valid data files for a GSE 
# Params: gse (GSE accession number)
# Return: a list of file download links
getValidFiles <- function(gse) {
   files <- getGEOSuppFiles(gse, fetch_files = FALSE)
   sapply(files$fname, getDataType)
   
}

# Function: check whether the filename is valid for processed datag
getDataType<- function(fname){
   print("Called")
   if(grepl("\\.csv", fname, ignore.case = TRUE, perl = TRUE)) {
      # Patterns
      normalized <- "(?=.*normalized)(?=.*count)"
      raw <- "(?=.*raw)(?=.*count)"
      fpkm <- "fpkm"
      rpkm <- "rpkm"
      count <- "count"
      if(grepl(normalized, fname, ignore.case = TRUE, perl = TRUE) 
         && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE)) 
      {
         print(paste(fname, "normalized counts"))
         return()
      } 
      
      else if(grepl(fpkm, fname, ignore.case = TRUE, perl = TRUE) 
                && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE))
      {  
         print(paste(fname, "fpkm")) 
         return()
      }
      
      else if(grepl(rpkm, fname, ignore.case = TRUE, perl = TRUE) 
                && !grepl(raw, fname, ignore.case = TRUE, perl = TRUE))
      {
         print(paste(fname, "rpkm")) 
         return()
      } 
      
      else if(grepl(raw, fname, ignore.case = TRUE, perl = TRUE) 
              || grepl(count, fname, ignore.case = TRUE, perl = TRUE)) 
         
      {  
         print(paste(fname, "raw")) 
         return()
      }

   } 
}

