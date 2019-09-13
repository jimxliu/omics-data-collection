library(GEOquery)


# Function: download supp csv files for a GSE that follow certain naming patterns
# Params: gse (GSE accession number)
# Return: print out downloaed filenames
downloadValidFiles <- function(gse) {
   files <-  getGEOSuppFiles(gse, fetch_files = FALSE)
   files$fileType <- sapply(files$fname, getFileType)
   for(row in 1:nrow(files)) {
      fileType <- files$fileType[[row]]
      if(!is.null(fileType)){
         url <- as.character(files[row, "url"])
         fname <- as.character(files[row, "fname"])
         download.file(url = url, destfile = paste0("./data/",fname))
         print(paste("Downloaded.", "File Name:", fname, ", File Type:", fileType))
      }
   }
   
}


# Function: check whether the filename is valid for processed datag
getFileType<- function(fname){
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
         # print(paste(fname, "normalized_counts"))
         return("normalized_counts")
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
         # print(paste(fname, "raw")) 
         return("raw")
      }
   } 
   return()
}

