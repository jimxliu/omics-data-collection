library(rentrez)
library(GEOquery)
library(hash)


# param: results, results of entrez_search(), esearch
# return: stdout
showAllFileFormats <- function(results) {
   supp_format_list <- lapply(results$ids, function(id) {
                                             recsum <- entrez_summary(db='gds', id=id)
                                             suppfiles <- extract_from_esummary(recsum, c('suppfile'))
                                             return(suppfiles)})
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

# param: recsum, esummary_list
# return: a list of boolean, indexed by gse_id
isSingleTaxon <- function(recsum){
   my_list <- lapply(recsum, function(rec) length(unlist(strsplit(rec$taxon, "; "))) == 1)
   return(my_list)
}


# param: organism
# return: results, esearch results
getHTSeqResultsByOrganism <- function(organism){
   dataset_type <- "expression profiling by high throughput sequencing"
   return(getResults(organism, dataset_type))
}


# param: organism.
# param: dataset_type, e.g. "expression profiling by high throughput sequencing", etc.
# param: suppfile_type, e.g. CSV, TXT, TLS, etc.
# return: results, esearch results
getResults <- function(organism, dataset_type, suppfile_type = "", pub_date = "2019/01/01-2019/12/31") {
   organism <- paste(organism, "[Organism]")
   dataset_type <- paste(dataset_type, "[DataSet Type]")
   date_string <- parseStrToPubDates(pub_date)
   inputs <- c(organism, dataset_type, date_string)
   if(suppfile_type != ""){
      suppfile_type <- paste(suppfile_type, "[Supplementary Files]")
      inputs <- c(inputs, suppfile_type)
   }
   # Form query
   query <- paste(inputs, collapse = " AND ")
   
   # Search the first time to get number of GSE records
   # res <- entrez_search(db='gds', term=query, use_history=TRUE)
   
   # Search the second time set the max number of records to res$count 
   res <- entrez_search(db='gds', term=query ,retmax=99999999, use_history=TRUE)
   
   return(res)
}

# Function: download supp files for a GSE that follow certain naming patterns
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


# param: uid, a string of digits returned from result$ids, e.g., 20012345
# return: GSE accession number, e.g., GSE12345
parseIdToAccession <- function(id){
   num <- gsub("[1-9]+0+([1-9]+[0-9]*)$", "\\1", "200138028")
   return(paste0("GSE",num))
}

# param: date_str, e.g., "2019/01/01-2019/12/31", "2019/09/01-present"
# return: date_query, e.g., "2019/09/01 [Publication Date] : 3000 [Publication Date]"
parseStrToPubDates <- function(date_str){
   dates <- strsplit(date_str, "-")[[1]]
   if(dates[1] == "present") {
      dates[1] = "3000"
   } 
   if(dates[2] == "present") {
      dates[2] = "3000"
   }
   date_query <- sprintf("%s [Publication Date] : %s [Publication Date]", dates[1], dates[2])
   return(date_query)
}

