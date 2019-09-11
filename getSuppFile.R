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


# Function: get the valid data files for a GSE 
# Params: gse (GSE accession number)
# Return: a list of file download links
getValidFileLinks <- function(gse) {
   files <- getGEOSuppFiles(gse, fetch_files = FALSE)
   valid_list <- c()
   sapply(1:1, function(row) 
                  if(checkType(files$fname[row])) {
                     valid_list <- c(valid_list, row)
                  })
   return(valid_list)
}

# Function: check whether the filename is valid for processed datag
getDataType<- function(fname){
   if(grepl("\\.csv", fname, ignore.case = TRUE, perl = TRUE)) {
      normalized <- "fpkm|rpkm|normalized"
      return("normalized")
      raw <- "raw|count"
      return("raw")
      
   } 
   
   return(NA)
}

fn <- "GSE129683_DESeq2_Bif1Bif4_v_WT_greenhouse2017.csv.gz"
isValidFormat("asfsda_csv")
