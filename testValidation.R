source("./utilities.R")

organism <- "Homo sapiens"
results <- getHTSeqResultsByOrganism(organism = organism)

tryCatch({
   ids <- results$ids
}, error=function(e){
   stop(sprintf("Error: %s", e))
})
rm(results)
outdir <- paste0("output/", tolower(gsub(" ", "_", organism)))
tryCatch({
   if(!dir.exists(outdir)){
      dir.create(outdir)
   }
}, error=function(e){
      stop(e)
})

for(uid in ids){
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

print("Done")
