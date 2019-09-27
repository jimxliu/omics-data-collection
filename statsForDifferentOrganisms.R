library(rentrez)
source("./utilities.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")


organism <- "Zea mays"

results <- getHTSeqResultsByOrganism(organism, pub_date = "1000/01/01-present")

results$ids

count <- 0
for(id in results$ids){
   gse <- parseIdToAccession(id)
   print(sprintf("Processing %s", gse))
   
   eList <- tryCatch({
      getGEO(gse)
   }, error = function(e) {
      print("Cannot fetch data, SKIP!")
      NULL
   })
   # if there is error fetching the data or has multiple organisms
   if(is.null(eList) || length(eList) > 1) {
      next
   }
   pd <- pData(eList[[1]])
   if(organism == "Zea mays"){
      version <- getGenomeVersion(pd)
      if(is.null(version)) {
         next
      }
   }
   if(isSingleCell(pd)){
      next
   }

   # has valid data files?
   files <- getValidFiles(gse = gse, organism = organism)
   if(!is.null(files)){
      count <- count + 1
   }
}
count

pData(getGEO("GSE102036")[[1]])
getGEOSuppFiles("GSE102036", fetch_files = FALSE, makeDirectory = FALSE)
?getGEOSuppFiles