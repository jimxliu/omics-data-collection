library(rentrez)
library(GEOquery)

rec <- entrez_search("gds", "GSE71448 [GEO Accession]")
rec
rec$file

recsum <- entrez_summary(db="gds", id=200071448)
recsum$pubmedids


