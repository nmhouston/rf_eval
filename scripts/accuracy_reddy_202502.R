#accuracy_reddy_202502
#calculate mean accuracy for Rhymefindr results on each chronological file

library(tidyverse)
library(fs)

evaldir<-"C:/data/JCLS2025/reddy/eval/"
texts_paths<-path_filter(dir_ls(evaldir), glob = "*_eval.csv")
texts_names<-path_ext_remove(path_file(texts_paths))

filename<-vector("character", length=length(texts_paths)) 
mean_correct<-vector("double", length=length(texts_paths))
num_entries<-vector("double", length=length(texts_paths))

for (i in 1:length(texts_paths)){
  df<-read_csv(texts_paths[i])
  filename[i]<-texts_names[i]
  mean_correct[i]<-mean(df$correct)
  num_entries[i]<-length(df$textid)
 }

df<-tibble(filename, mean_correct, num_entries)
write_csv(df, paste0(evaldir, "mean_correct.csv"))

