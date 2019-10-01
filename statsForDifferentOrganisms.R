library(rentrez)
source("./utilities.R")
source("./getGenomeVersion.R")

organisms <- c("Arabidopsis thaliana", "Glycine max", "Canis lupus familiaris", "Felis catus", "Escherichia coli", "Influenza A virus")
# organisms <- c("Homo sapiens", "Mus musculus")


# organism <- "Saccharomyces cerevisiae"


for(organism in organisms){
   results <- getHTSeqResultsByOrganism(organism, pub_date = "")
   print(organism)
   print(results$count)
}
