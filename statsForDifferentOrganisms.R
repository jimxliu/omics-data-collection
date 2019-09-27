library(rentrez)
source("./utilities.R")
source("./getGenomeVersion.R")

# organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")
organisms <- c("Homo sapiens", "Mus musculus")


organism <- "Saccharomyces cerevisiae"


stats <- c()

for(organism in organisms){
   start_time <- proc.time()
   results <- getHTSeqResultsByOrganism(organism, pub_date = "2019/01/01-present")
   print(organism)
   print(results$count)
   # count <- 0
   # for(id in results$ids){
   #    gse <- parseIdToAccession(id)
   #    print(sprintf("Processing %s", gse))
   #    
   #    eList <- tryCatch({
   #       getGEO(gse, getGPL = FALSE)
   #    }, error = function(e) {
   #       print("Cannot fetch data, SKIP!")
   #       NULL
   #    })
   #    # if there is error fetching the data or has multiple organisms
   #    if(is.null(eList) || length(eList) > 1) {
   #       next
   #    }
   #    pd <- pData(eList[[1]])
   #    if(organism == "Zea mays"){
   #       version <- getGenomeVersion(pd)
   #       if(is.null(version)) {
   #          next
   #       }
   #    }
   #    if(isSingleCell(pd)){
   #       next
   #    }
   # 
   #    # has valid data files?
   #    files <- getValidFiles(gse = gse, organism = organism)
   #    if(!is.null(files)){
   #       count <- count + 1
   #    }
   # }
   # time <- proc.time() - start_time
   # stat_string <- sprintf("Organism: %s. Out of %d total results, %d have valid supp files. %nProcessing time: %s", organism, results$count, count, time[[3]])
   # stats <- c(stats, stat_string)
}

for(string in stats){
   print(string)
}