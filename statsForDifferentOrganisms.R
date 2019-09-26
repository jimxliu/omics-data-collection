library(rentrez)
source("./util.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")

organism <- "Homo sapiens"

res <- getHTSeqResultsByOrganism(organism)

total <- length(recsum)

for(organism in organisms){
   recsum <- getHTSeqResultsByOrganism(organism)
   total <- length(recsum)
}


gse_list <- extract_from_esummary(esummaries = recsum, elements = c("gse"))

