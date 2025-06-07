#evaluate_RK_method 

###########################
#This script compares the rhyme vectors found with the Rhymefindr script   
#with the gold standard annotations prepared by Reddy and Sonderegger, 
#using the methods outlined in Reddy and Knight 2011 and their code at 
#https://github.com/sravanareddy/rhymediscovery

#Note: in running this script, I discovered errors in a some of Reddy   
#and Sonderegger's gold annotated data. In some of their entries, the 
#number of words is different from the number of rhyme positions listed in 
#the vector. This script filters out those entries from the evaluation and 
#saves them for later examination.   


library(tidyverse)
library(fs)
evaldir<-"C:/data/rf_eval/reddy/eval/"

texts_names<-path_ext_remove(path_file(path_filter(dir_ls(evaldir, 
                                                          glob="*_eval.csv"))))
texts_names<-str_remove(texts_names, "_eval")


RK_eval_results<-tibble(textid=character(),
                        RK_accuracy = numeric(),
                        RK_precision = numeric(),
                        RK_recall = numeric(),
                        RK_F_score = numeric()
                        )

for (t in 1:length(texts_names)){
    df<-read_csv(paste0(evaldir, texts_names[t], "_eval", ".csv"))
    
  #start the totals at zero 
  tot_p <- 0
  tot_r <- 0
  tot_words <- 0
  
  # RK compare each word in stanza to the future words in the stanza 
  for (i in 1:nrow(df)) {
    gold_scheme <- unlist(strsplit(df$goldvector[i], " "))
    found_scheme <- unlist(strsplit(df$rfnum[i], " "))
    
    for (wi in seq_along(gold_scheme)) {
      if (wi == length(gold_scheme)) next
      
      # Gold rhymeset: set of future words in the stanza that rhyme with this one
      #absolute indices j > wi where gold[j] == gold[wi]
      g_slice <- gold_scheme[(wi+1):length(gold_scheme)]
      g_rhymeset_rel <- which(g_slice == gold_scheme[wi])
      g_rhymeset <- if (length(g_rhymeset_rel) > 0) g_rhymeset_rel + wi else integer(0)
      
      # Found rhymeset: same for found_scheme
      f_slice <- found_scheme[(wi+1):length(found_scheme)]
      f_rhymeset_rel <- which(f_slice == found_scheme[wi])
      f_rhymeset <- if (length(f_rhymeset_rel) > 0) f_rhymeset_rel + wi else integer(0)
      
      if (length(g_rhymeset) == 0) next
      tot_words <- tot_words + 1
      if (length(f_rhymeset) == 0) next
      
      correct <- length(intersect(g_rhymeset, f_rhymeset))
      precision <- correct / length(f_rhymeset)
      recall <- correct / length(g_rhymeset)
      tot_p <- tot_p + precision
      tot_r <- tot_r + recall
    }
  }

  
  # metrics
  precision <- tot_p / tot_words
  recall <- tot_r / tot_words
  #RK's F score is averaged over all words over all stanzas
  F_score <- (2 * precision * recall) / (precision + recall)
  #RK define accuracy as exact match by stanza scheme 
  RK_accuracy<-length(which(df$goldvector==df$rfnum))/nrow(df)

  # overall results 
  this_result<- tibble(
    textid = texts_names[t],
    RK_accuracy = RK_accuracy,
    RK_precision = precision,
    RK_recall = recall,
    RK_F_score = F_score
  )
  RK_eval_results<-bind_rows(RK_eval_results, this_result)
}
write_csv(RK_eval_results, paste0(evaldir, "RK_eval_results.csv"))