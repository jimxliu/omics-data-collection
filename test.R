library(rentrez)
library(GEOquery)

# obtain a list of all GSE records associated with Maize and Gene expression profiling.
res <- entrez_search(db='gds', term='Zea mays[ORGN] AND expression profiling by array[GTYP]', use_history=TRUE)
res$count
# number of gse records
# n_records = res$count
n_records = 5 
res <- entrez_search(db='gds', term='Zea mays[ORGN] AND expression profiling by array[GTYP]', retmax=n_records, use_history=TRUE)
summary(res)

# get the summary of each record by its record id.
recsum <- entrez_summary(db='gds', id=res$ids)
recsum

# extract the accession id and list of samples (GSM) of each GEO series
gse_list <- extract_from_esummary(recsum, c('gse','samples'))
gse_list


# for (i in 1:n_records){
for (i in 1:1){
   gse_access <- paste0("GSE",gse_list["gse",i])
   print(paste(gse_access))
   dname <- paste0("./", gse_access)
   if(dir.exists(dname)){
      unlink(dname, recursive = TRUE)
   }
   dir.create(dname)
   
   samples <- gse_list["samples", i][[1]] # samples is a data.frame now
  
   for ( j in 1:nrow(samples)){
      # print(paste(samples$accession[j]))
      gsm_access <- samples$accession[j]
      gsm <- getGEO(gsm_access)
      data <- Table(gsm)
      
      fname <- sprintf("./%s/%s.csv", gse_access,gsm_access) 
      write.csv(data, file = fname, sep = ",", row.names = FALSE)
   }
}
