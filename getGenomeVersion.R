library(GEOquery)

gsm <- getGEO("GSM3027154", )
meta <- Meta(gsm)
class(meta)
names(meta)
for(line in meta$data_processing){
   if(grepl("genome_build", tolower(line), perl=TRUE)) {
      print(line)
   }
}
