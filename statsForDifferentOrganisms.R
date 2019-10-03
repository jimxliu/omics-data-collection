library(rentrez)
source("./utilities.R")
source("./getGenomeVersion.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Mus musculus", "Arabidopsis thaliana", "Glycine max", "Canis lupus familiaris", "Felis catus", "Escherichia coli", "Influenza A virus")

for(organism in organisms){
   tryCatch({
      results <- getHTSeqResultsByOrganism(organism, pub_date = "")
      print(organism)
      totalCount <- results$count
      print(results$count)
      ids <- results$ids
      rm(results)
   }, error=function(e){
      stop(sprintf("Error getting results: %s", e)) 
   })
   outdir <- paste0("output/", tolower(gsub(" ", "_", organism)))
   tryCatch({
      if(!dir.exists(outdir)){
      dir.create(outdir)
      }
   }, error=function(e){
      stop(e)
   })
   count <- 1
   for(uid in ids){
      print(sprintf("Progress: %d/%d for %s", count, totalCount, organism))
      count <- count + 1
      gse <- parseIdToAccession(uid)
      print(sprintf("uid: %s, gse: %s", uid, gse))
      eList <- NULL
      eList <- tryCatch({
         getGEO(gse, getGPL = FALSE, destdir="./tmpData")
      }, error = function(e) {
         print(e)
         NULL
      })
      if(is.null(eList) || length(eList) != 1){
         next
      }
      pd <- pData(eList[[1]])
      files <- getValidFiles(gse = gse, organism = organism)
      if(!is.null(files)){
         outfile <- sprintf("%s/%s", outdir, gse)
         tryCatch({
            file.create(outfile)
         }, warning=function(w){
            print(w)
         }, error=function(e){
            print(e)
         })
      }
   }
}
