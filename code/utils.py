import pandas as pd
import re

def loadData(fname):
   df = None
   if re.search("\.csv$", fname):
      try:
         df = pd.read_csv(fname)
      except Exception as e:
         print e
         print "Skipped! Error loading data from {}".format(fname)    

   elif re.search("\.tsv$", fname):
      try:
         df = pd.read_csv(fname, sep="\t") # try tab separator
      except Exception as e:
         print e
         print "Skipped! Error loading data from {}".format(fname)   
   
   elif re.search("\.xlsx?$", fname):
      try:
         df = pd.read_excel(fname, index_col = 0)
      except Exception as e:
         print e
         print "Skipped! Error loading data from {}".format(fname)   

   elif re.search("\.txt$", fname):
      try:
         df = pd.read_csv(fname, sep = "\t")
      except Exception as e:
         print e
         try:
            df = pd.read_csv(fname)
         except Exception as e:
            print e
            print "Skipped! Error loading data from {}".format(fname)   
  
   return df

