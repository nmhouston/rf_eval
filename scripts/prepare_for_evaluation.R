#prepare_for_evaluation

####This script combines the Reddy corpus gold standard data with the rhyme 
#vectors found by Rhymefindr into one dataframe to use in running evaluation 
#metrics 

library(tidyverse)
library(fs)
datadir<-"C:/data/rf_eval/reddy/data/"
inputdir<-"C:/data/rf_eval/reddy/output/"
evaldir<-"C:/data/rf_eval/reddy/eval/"

texts_names<-path_ext_remove(path_file(path_filter(dir_ls(datadir))))

for (t in 1:length(texts_names)){
  #load gold data and predicted data 
  reddy<-read_csv(paste0(datadir, texts_names[t], ".csv"))
  rhymefindr<-read_csv(paste0(inputdir, texts_names[t], "_rf.csv"))
  
  #join the RK gold standard rhyme data with the vectors found by rhymefindr
  df<-left_join(reddy, rhymefindr, 
                join_by(textid, endwords==words))
  df2<-df %>% select(-sylls, -isrhymed, -perf)  
  
  #convert rhyme letters to numbers to match the RK data 
  df3<-df2 %>% rowwise() %>% 
    mutate(rfnum=paste(as.numeric(factor(str_split_1(ltrvec, " "))), 
                       collapse=" ")) %>% 
    relocate(rfnum, .after = goldvector)   
  
  #filter out items where the number of rhymes in the RK gold data does not match
  #the number of words
  df4<-df3 %>% mutate(throw_out=if_else(
    length(str_split_1(goldvector, " "))!=
      length(str_split_1(rfnum, " ")), 1, 0)) 
  
  data_errors<-df4 %>% filter(throw_out==1)
  df5<-df4 %>% filter(throw_out==0) %>% select(-throw_out)
  
  #save combined data file and items with errors
  write_csv(data_errors, paste0(evaldir, texts_names[t], "_error", ".csv"))
  write_csv(df5, paste0(evaldir, texts_names[t], "_eval", ".csv"))
}  