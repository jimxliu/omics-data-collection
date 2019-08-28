library(rentrez)

# obtain a list of all GSE records associated with Maize and Gene expression profiling.
res <- entrez_search(db='gds', term='Zea mays[ORGN] AND expression profiling by array[GTYP]', use_history=TRUE)
res$count
res <- entrez_search(db='gds', term='Zea mays[ORGN] AND expression profiling by array[GTYP]', retmax=res$count, use_history=TRUE)
summary(res)

# get the summary of each record by its record id.
recsum <- entrez_summary(db='gds', id=res$ids)
recsum

# extract the accession id and list of samples (GSM) of each GEO series
gse_list <- extract_from_esummary(recsum, c('gse','samples'))
gse_list

# row names of gse_list
rownames(gse_list)

# number of GEO series
N <- ncol(gse_list)
N


# get the gse accession id of the first record
gse_acc <- gse_list["gse",1]
gse_acc

# get the samples of the first record into a data frame
sample_tbl <- gse_list["samples",1][[1]]
sample_tbl
class(sample_tbl)

colnames(sample_tbl)

# get accession id of the first sample dataset
sample_tbl[1, "accession"]

# get title of the first sample dataset
title <- sample_tbl[1, "title"]
# split and reformat title
title <- gsub(" ", "_", title)


#### Process the all sample datasets in bulk ######

gses <- sapply(1:2, function(x) paste0("GSE",gse_list["gse",x]))
length(gses)

samples <- sapply(1:2, function(x) gse_list['samples',x])

# for the samples of the first GEO series
# list
class(samples[1])

# data.frame
class(samples[[1]])
df <- samples[[1]]
nrow(df)


# join accession and title for each record
sapply(1:nrow(df), function(x) paste(df$accession[x], df$title[x]))

# column names of df: accession, title
colnames(df)



##### get the table of an individual sample (GSM)
library(GEOquery)

#GSM3377457
gsm <- getGEO('GSM3377457')
class(Table(gsm)) # data.frame table

gsm_table <- Table(gsm)
head(gsm_table)

# store the gsm table in a mysql DB
store_data <- function(gsm_id) {
  # code goes here
  # https://stackoverflow.com/questions/12186839/writing-the-data-frame-to-mysql-db-table
}

