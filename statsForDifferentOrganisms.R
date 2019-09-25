library(rentrez)
source("./util.R")

organisms <- c("Zea mays", "Saccharomyces cerevisiae", "Homo sapiens", "Mus musculus")

organism <- "Zea mays"

recsum <- getHTSeqSummmaryByOrganism(organism)

total <- length(recsum)