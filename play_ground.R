library(GEOquery)
library(rentrez)

files <- getGEOSuppFiles("GSE132620", fetch_files = FALSE)




recsum <- entrez_summary(db='gds', id="200132620")

recsum$suppfile