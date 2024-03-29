source("./utilities.R")
source("./getGenomeVersion.R")
source("./isSingleCell.R")

organism <- "Mus musculus"
results <- getHTSeqResultsByOrganism(organism = organism)
count <- 0
batch <- 150
n <- ceiling(results$count / batch)
outfile <- paste0("output/", tolower(gsub(" ", "_", organism)), ".out")
for(i in 1:n){
   start <- (i - 1) * batch + 1
   end <-  min(i * batch, results$count)
   print(sprintf("start: %d, end: %d", start, end))
   esummaries <- entrez_summary(db="gds", id=results$ids[start:end])
   for(esum in esummaries){
      
      # Ignore GSE containing multipl organisms
      if(length(strsplit(esum$taxon, ";")[[1]]) > 1){
         next
      }
      gse <- paste0("GSE",esum$gse)
      eList <- tryCatch({
         getGEO(gse, getGPL = FALSE, destdir="./tmpData")
      }, error = function(e) {
         print(e)
         NULL
      })
      if(is.null(eList)){
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
         write(gse, file = outfile, append = TRUE)
      }
   }
}

print(sprintf("Total: %d, Valid: %d", results$count, count))
