library(rentrez)
source("./utilities.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")


organism <- "Mus musculus"

results <- getHTSeqResultsByOrganism("Zea mays")

results$count

count <- 0
for(id in results$ids){
   # recsum <- entrez_summary(db='gds', id=id)
   # suppfiles <- extract_from_esummary(recsum, c('suppfile'))
   # if(!is.null(suppfiles) && length(suppfiles) > 0){
   #    count = count + 1  
   # }
   gse <- parseIdToAccession(id)
   print(sprintf("Processing %s", gse))
   eList <- tryCatch({ 
      getGEO(gse)
   }, error = function(e) {
      print("Cannot fetch data, SKIP!")
      return()
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
   
}
