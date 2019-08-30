library(rentrez)
library(GEOquery)

# Obtain a list of all GEO series (GSE) associated with Maize and Gene expression profiling.
res <- entrez_search(db='gds', term='Zea mays [Organism] AND expression profiling by high throughput sequencing[DataSet Type]', use_history=TRUE)
res$count
# Get number of GSE records
# n_records = res$count
n_records = 20
res <- entrez_search(db='gds', term='Zea mays [Organism] AND expression profiling by high throughput sequencing[DataSet Type]', retmax=n_records, use_history=TRUE)
summary(res)

# Summary of each record by its record id.
recsum <- entrez_summary(db='gds', id=res$ids)
recsum

# Extract the accession id and list of samples (GSM) of each GSE
gse_list <- extract_from_esummary(recsum, c('gse','suppfile'))
gse_list

gse_list["suppfile",1]

filePaths <- getGEOSuppFiles("GSE121039")

?getGEOSuppFiles
colnames(filePaths)