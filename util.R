library(rentrez)
library(GEOquery)
library(hash)

showAllFileFormats <- function(recsum) {
   supp_format_list <- extract_from_esummary(recsum, c('suppfile'))
   
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