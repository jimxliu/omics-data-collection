library(rentrez)
source("./util.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")

organism <- "Mus musculus"

results <- getHTSeqResultsByOrganism(organism)
results$file
recsum <- entrez_summary(db='gds', id=results$ids)

class(res)
count <- 0
for(id in results$ids){
   recsum <- entrez_summary(db='gds', id=id)
   suppfiles <- extract_from_esummary(recsum, c('suppfile'))
   if(!is.null(suppfiles) && length(suppfiles) > 0){
      count = count + 1  
   }
}
id

supp_format_list <- lapply(results$ids, function(id) {
   recsum <- entrez_summary(db='gds', id=id)
   suppfiles <- extract_from_esummary(recsum, c('suppfile'))
   print(suppfiles)
   return(suppfiles)})


showAllFileFormats(results)



total <- length(recsum)

for(organism in organisms){
   recsum <- getHTSeqResultsByOrganism(organism)
   total <- length(recsum)
}


gse_list <- extract_from_esummary(esummaries = recsum, elements = c("gse"))

