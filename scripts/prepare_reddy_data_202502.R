#prepare_reddy_data_202502

#This script takes as input the text files downloaded from Reddy and Sonderegger's 
#Chicago Rhyming Poetry Corpus (https://github.com/sravanareddy/rhymedata) 
#and outputs columnar data (csv).
#While running this script, I discovered errors in
#the 1617.pgold and 1718.pgold files that would prevent accurate parsing 
#into columns.  To correct those errors, I removed two entries and edited a 
#third (documented in the data memo) to be able to process the data files. 


library(tidyverse)
library(fs)
reddydir<-"C:/data/JCLS2025/reddy/"
reddydata<-"C:/data/JCLS2025/reddy/data/"
texts_paths<-path_filter(dir_ls(reddydir), glob="*_pgold.txt")
texts_names<-path_ext_remove(path_file(texts_paths))

for (i in 1:length(texts_paths)){
 df<-data.frame(scan(file=texts_paths[i], 
                          multi.line=TRUE,
                          what=list(words="", goldvector="", vector2=""), 
                          sep = "\n"))
  df<-df %>% 
  separate_wider_regex(words, c(poem="POEM[0-9]+", " ", 
                                endwords=".*")) %>% 
    rowid_to_column() %>% 
    rename(textid=rowid) %>% select(-vector2)
  write_csv(df, paste0(reddydata, texts_names[i], ".csv"))
}