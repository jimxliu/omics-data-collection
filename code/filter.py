import pandas as pd
import os, re
from utils import loadData, longestRegion

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
#fname = "../data/zea_mays/GSE50191_FPKM.tsv"
#fname = "../data/zea_mays/GSE67550_FPKM_table.txt"

def processFPKM(fname):
   df = loadData(fname)
   if df is None:
      return None
   # For the columns whose dtype is object, or "O", check if the values match gene id pattern
   gene_id_pattern = "AC\d+\.\d+_FG[0-9a-zA-Z_]+|Zm[0-9a-zA-Z_]+|GRMZM[0-9a-zA-Z_]+"   
   gene_id_col = None
   for col in df.columns:
      if df.dtypes[col] == "O":      
         series = df.loc[:10, col]
         if series.str.contains(gene_id_pattern, regex = True).any():
            # Extract the column data as a Series.
            gene_id_col = df[col]
            break

   if gene_id_col is not None:
      # Remove columns with dtype "int64"
      df = df.select_dtypes(exclude = ["int32", "int64"])

      # Find and extract the most number of consecutive columns with dtype "float64"
      start, end = longestRegion(df.dtypes, "float64")
      # data_cols: fpkm data columns
      data_cols = df.columns.tolist()[start:end+1]
      # Only eep column names containing FPKM. If none, use the original data_cols
      fpkm_cols = [col for col in data_cols if re.search("fpkm", col.lower())]
      data_cols = [col for col in data_cols if "length" not in col.lower()] if not fpkm_cols else fpkm_cols
      # Rearrange columns
      new_cols = ["GeneID"] + data_cols
      df = df[data_cols]
      df["GeneID"] = gene_id_col
      df = df[new_cols]
      # Replace characters that are not [0-9a-zA-Z_] in the column names with "_"
      df = df.rename(mapper = lambda x: re.sub("[^0-9a-zA-Z_]+", "_", x), axis = "columns")
      # Remove rows containing NaN
      df = df.dropna()
      return df

   return None

#count = 0
#total = 0
#for f in os.listdir(path):
#   fname = os.path.join(path, f)
#   if os.path.isfile(fname): 
#      if "fpkm" in f.lower() and "diff" not in f.lower():
#         total += 1
#         df = processFPKM(fname) 
#         #if df is None:
#         #   count += 1
#         #   print "Error processing {}".format(fname) 
#         if df is not None:
#            print f
#            print df.head()
#            print
         
df = processFPKM("../data/zea_mays/GSE71723_transcript_fpkms.txt")            
print df.head()
