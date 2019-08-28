library(GEOquery)

######## GSE119550 ######### 
gse <- getGEO('GSE119550')
# C:\Users\jimri\AppData\Local\Temp\RtmpaEcDS1/GPL22405.soft

#  [1] "GSM3377468" "GSM3377465" "GSM3377457" "GSM3377455" "GSM3377469" "GSM3377466" "GSM3377462" "GSM3377463" "GSM3377460"
# [10] "GSM3377467" "GSM3377464" "GSM3377459" "GSM3377461" "GSM3377456" "GSM3377458" "GSM3377470"

gsm <- getGEO('GSM3377468')
Meta(gsm)

class(Table(gsm))
# data.frame

Table(gsm)[1:5,]

####### ChIP-Seq dataset ########
# gse2 <- getGEO('GSE61954')
# gse2
# 
# gsm2 <- getGEO('GSM1517641')
# Meta(gsm2)

