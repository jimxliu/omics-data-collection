library(hash)
# install.packages("stringr")
library(stringr)

   
getGenomeVersion <- function (pd) {
   for( name in names(pd)){
      
      if(grepl("data_processing", name, ignore.case = TRUE, perl = TRUE) &&
         any(grepl("genome_build", pd[[name]], ignore.case = TRUE, perl = TRUE)))
      {
         gv_set <- hash() 
         sapply(pd[[name]], function(line) 
                           if(!is.na(str_extract(tolower(line), "v[0-9]+|version[-\\s][0-9]+"))){
                              gv_set[str_extract(tolower(line), "v[0-9]+|version[-\\s][0-9]+")] <- 1
                           })

         if(length(gv_set) == 1){
            return(keys(gv_set)[[1]])
         }
         clear(gv_set)
      }
   }
   return(NULL)
}

