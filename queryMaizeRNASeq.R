library(rentrez)
library(GEOquery)

# Obtain a list of all GEO series (GSE) associated with Maize and Gene expression profiling.
res <- entrez_search(db='gds', term='Zea mays [Organism] AND expression profiling by high throughput sequencing[DataSet Type]', use_history=TRUE)
res$count
# Get number of GSE records
# n_records = res$count
n_records = 5 
res <- entrez_search(db='gds', term='Zea mays [Organism] AND expression profiling by high throughput sequencing[DataSet Type]', retmax=n_records, use_history=TRUE)
summary(res)

# Summary of each record by its record id.
recsum <- entrez_summary(db='gds', id=res$ids)
recsum

# Extract the accession id and list of samples (GSM) of each GSE
gse_list <- extract_from_esummary(recsum, c('gse','samples'))
gse_list


# Process each GSE
# for (i in 1:n_records){
for (i in 1:1){
   
   # Get GSE accession number
   gse_access <- paste0("GSE",gse_list["gse",i])
   print(paste0("Processing: ", gse_access))
   
   # Create GSE-specific directory to store data
   dname <- paste0("./", gse_access)
   if(dir.exists(dname)){
      unlink(dname, recursive = TRUE)
   }
   dir.create(dname)
   
   # Get the GSM-title mapping
   sample_map <- gse_list["samples",i][[1]]
   
   # Store the mapping
   write.csv(sample_map, file = paste0(dname,"/sample_mapping.csv"), row.names = FALSE)
   
   # samples is a data.frame now
   samples <- gse_list["samples", i][[1]] 
  
   # Process each GSM sample
   # for ( j in 1:nrow(samples)){
   for ( j in 1:1){
      print(paste0("   Processing: ",samples$accession[j]))
      
      # GSM Accession number
      gsm_access <- samples$accession[j]
      
      # Get dataset as a data.frame
      gsm <- getGEO(gsm_access)
      data <- Table(gsm)
      
      # Store dataset to csv
      fname <- sprintf("./%s/%s.csv", gse_access,gsm_access) 
      write.csv(data, file = fname, row.names = FALSE)
   }
}

print("Done")

