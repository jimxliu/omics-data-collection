source("./utilities.R")

organism <- "Zea mays"

srcdir <- paste0("./output/", tolower(gsub(" ", "_", organism)))

files <- list.files(srcdir)

destdir <- sprintf("./data/%s", tolower(gsub(" ", "_", organism)))
tryCatch({
   if(!dir.exists(destdir)){
      dir.create(destdir, recursive=TRUE)
   }
}, error=function(e){
   stop(e)
}, warning=function(w){
   stop(w)
})

for(fname in files){
   gse <- fname
   print(sprintf("Accession: %s, Organism: %s", gse, organism))
   tryCatch({
      getValidFiles(gse = gse, organism = organism, download = TRUE)
   }, error=function(e){
      print(sprintf("Error: %s", e))
   }, warning=function(w){
      print(w)
   })
}

print("Downloading finished.")
