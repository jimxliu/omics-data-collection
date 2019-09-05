library(rentrez)
library(GEOquery)

rec <- entrez_search("gds", "GSE71448 [GEO Accession]")
rec
rec$file

recsum <- entrez_summary(db="gds", id=200071448)
recsum$pubmedids

entrez_dbs()


 
rec <- entrez_search("gds", "GSM1834812 [GEO Accession]")
rec$ids
recsum2 <- entrez_summary(db="gds", id=rec$ids)
names(recsum2)

