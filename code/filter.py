import pandas as pd
import os, re
from utils import loadData

organism = "Zea mays"

organism = re.sub("\s+", "_", organism).lower()

path = "../data/" + organism

#files = [os.path.join(path, f) for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]

# CSV
#for f in files:
#   if f.lower().endswith(".csv"):
#      print f 

#fname = "../data/zea_mays/GSE83411_annotation_and_FPKM_expression_master_file.csv"
#fname = "../data/zea_mays/GSE130930_seed_fpkm.txt"
#fname = "../data/zea_mays/GSE137826_kenwang_FPKM.csv"
fname = "../data/zea_mays/GSE50191_FPKM.tsv"


df = loadData(fname)

# Select columns whose dtype is object, or "O", indicating string values
gene_id_pattern = "AC\d+\.\d+_FG[0-9a-zA-Z_]+|Zm[0-9a-zA-Z_]+|GRMZM[0-9a-zA-Z_]+"   
for col in df.columns:
   if df.dtypes[col] == "O":      
      series = df.loc[:10, col]
      if series.str.contains(gene_id_pattern, regex = True).any():
         print(col)

