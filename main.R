
if(!requireNamespace("BiocManager", quitely = TRUE)){ 
   install.packages("BiocManager")
}

if(!requireNamespace("GEoquery", quietly = TRUE)) {
   BiocManager::install("GEOquery")
}

if(!requireNamespace("rentrez", quietly = TRUE)){
   install.packages("rentrez")
}

if(!require("hash")) {
   install.packages("hash")
}


library(rentrez)
library(GEOquery)
library(hash)
# library(stringr)


