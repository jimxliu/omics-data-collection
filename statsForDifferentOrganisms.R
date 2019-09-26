library(rentrez)
source("./utilities.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")


organism <- "Mus musculus"

results <- getHTSeqResultsByOrganism("Zea mays")
results$count
recsum <- entrez_summary(db='gds', id=results$ids)

class(results$ids[1])
class(1)

count <- 0
for(id in results$ids){
   # recsum <- entrez_summary(db='gds', id=id)
   # suppfiles <- extract_from_esummary(recsum, c('suppfile'))
   # if(!is.null(suppfiles) && length(suppfiles) > 0){
   #    count = count + 1  
   # }
      
}

getPubDatesFromString("2019/01/01-present")


showAllFileFormats(results)



total <- length(recsum)

for(organism in organisms){
   recsum <- getHTSeqResultsByOrganism(organism)
   total <- length(recsum)
}


gse_list <- extract_from_esummary(esummaries = recsum, elements = c("gse"))

