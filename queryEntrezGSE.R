library(rentrez)

entrez_dbs()

entrez_db_searchable(db='gds')
# entrez_db_searchable(db='pubmed')

res <- entrez_search(db='gds', term='Zea mays[ORGN] AND expression profiling by array[GTYP]', retmax=20, use_history=TRUE)
res$count
summary(res)

length(res$ids) == res$count
res$ids
# recs <- entrez_fetch(db='gds', id=res$ids, rettype='xml', parsed=TRUE)
recsum <- entrez_summary(db='gds', id=res$ids)
recsum[1]
extract_from_esummary(recsum, 'gse')[1]
# 119550 (GSE119550)
extract_from_esummary(recsum, 'title')[1]
extract_from_esummary(recsum, 'samples')[1]
#  [1] "GSM3377468" "GSM3377465" "GSM3377457" "GSM3377455" "GSM3377469" "GSM3377466" "GSM3377462" "GSM3377463" "GSM3377460"
# [10] "GSM3377467" "GSM3377464" "GSM3377459" "GSM3377461" "GSM3377456" "GSM3377458" "GSM3377470"

