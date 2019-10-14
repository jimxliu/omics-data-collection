import pandas as pd
import re

__all__ = ["loadData", "longestRegion"]

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
   else:
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

# param: li, list object
# param: target, string
# return: (start, end), denoting the start and end index of the longest region with same objects
def longestRegion(li, target):
   start = end = 0
   max_start = 0
   max_end = -1
   for i in range(len(li)):
      if li[i] != target:
         start = -1
      else:
         if start == -1:
            start = i
         end = i
         if max_end - max_start < end - start:    
            max_end = end
            max_start = start
   return (max_start, max_end)









