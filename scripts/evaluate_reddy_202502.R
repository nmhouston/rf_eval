#evaluate_reddy_202502
#This script compares the rhyme vectors found with the Rhymefindr script   
#with the gold standard annotations prepared by Reddy and Sonderegger. 

#Note: in running this script, I discovered errors in a some of Reddy   
#and Sonderegger's gold annotated data. In some of their entries, the 
#number of words is different from the number of rhyme positions listed in 
#the vector. This script filters out those entries from the evaluation and 
#saves them for later examination.   


library(tidyverse)
library(fs)
datadir<-"C:/data/JCLS2025/reddy/data/"
inputdir<-"C:/data/JCLS2025/reddy/output/"
evaldir<-"C:/data/JCLS2025/reddy/eval/"
texts_paths<-path_filter(dir_ls(inputdir))
texts_names<-path_ext_remove(path_file(texts_paths))

for (i in 1:length(texts_names)){
  reddy<-read_csv(paste0(datadir, texts_names[i], ".csv"))
  rhymefindr<-read_csv(paste0(inputdir, texts_names[i], ".csv"))
  df<-left_join(reddy, rhymefindr, 
                join_by(textid, endwords==words))
  df2<-df %>% select(-sylls, -isrhymed)
  
  df3<-df2 %>% rowwise() %>% 
    mutate(rfnum=paste(as.numeric(factor(str_split_1(ltrvec, " "))), 
        collapse=" ")) %>% 
    relocate(rfnum, .after = goldvector)   
  
  df4<-df3 %>% mutate(throw_out=if_else(
    length(str_split_1(goldvector, " "))!=
             length(str_split_1(rfnum, " ")), 1, 0)) 
  
  data_errors<-df4 %>% filter(throw_out==1)
  write_csv(data_errors, paste0(evaldir, texts_names[i], "_error", ".csv"))    

  df5<-df4 %>% filter(throw_out==0)
  
  df6<-df5%>% 
     mutate(eval=length(which(str_split_1(goldvector, " ")==
                               str_split_1(rfnum, " ")))) %>% 
    relocate(eval, .after=rfnum) %>% 
    mutate(veclength=length(str_split_1(rfnum, " "))) %>% 
    mutate(correct=eval/veclength) %>% 
    relocate(correct, .after=eval)
  
  df7<-df6 %>% mutate(percent_perf=
                        sum(as.numeric(str_split_1(perf, " ")))/veclength) %>% 
    relocate(percent_perf, .after=correct)
  
  
  write_csv(df7, paste0(evaldir, texts_names[i], "_eval", ".csv"))

} 