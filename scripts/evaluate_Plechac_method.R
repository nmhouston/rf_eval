#evaluate_Plechac_method


###########################
#This script compares the rhyme vectors found with the Rhymefindr script   
#with the gold standard annotations prepared by Reddy and Sonderegger, 
#using the methods outlined in Plechac 2018. 


library(tidyverse)
library(fs)
evaldir<-"C:/data/rf_eval/reddy/eval/"

texts_names<-path_ext_remove(path_file(path_filter(dir_ls(evaldir, 
                                                          glob="*_eval.csv"))))
texts_names<-str_remove(texts_names, "_eval")

# function to convert pairs to string format  
pair_to_str <- function(p) paste(sort(p), collapse = "-")


PP_eval_results<-tibble(textid=character(),
                        PP_precision = numeric(),
                        PP_recall = numeric(),
                        PP_F_score = numeric()
                      )

for (t in 1:length(texts_names)){
  df<-read_csv(paste0(evaldir, texts_names[t], "_eval", ".csv"))
 
# Initialize corpus pair totals
  corpus_gold_pairs <- 0
  corpus_found_pairs <- 0
  corpus_intersect_pairs<-0

  for (i in 1:nrow(df)) {
    doc_gold_pairs<-list()
    doc_found_pairs<-list()
    
    gold_scheme <- unlist(strsplit(df$goldvector[i], " "))
    found_scheme <- unlist(strsplit(df$rfnum[i], " "))
    n <- length(gold_scheme)
  
  # Gold standard rhyme pairs
    for (j in 1:(n - 1)) {
      for (k in (j + 1):n) {
        if (gold_scheme[j] == gold_scheme[k]) {
          doc_gold_pairs <- append(doc_gold_pairs, list(c(j, k)))
        }
      }
    }
  
  # Found/predicted rhyme pairs
    for (j in 1:(n - 1)) {
      for (k in (j + 1):n) {
        if (found_scheme[j] == found_scheme[k]) {
          doc_found_pairs <- append(doc_found_pairs, list(c(j, k)))
        }
      }
    }
    doc_gold_set <- sapply(doc_gold_pairs, pair_to_str)    
    doc_found_set <- sapply(doc_found_pairs, pair_to_str) 
    doc_intersect_pairs<-intersect(doc_gold_set, doc_found_set)
    
    #increase the corpus totals with info from this document
    corpus_gold_pairs <-(corpus_gold_pairs + length(doc_gold_set))
    corpus_found_pairs<-(corpus_found_pairs + length(doc_found_set))
    corpus_intersect_pairs <-(corpus_intersect_pairs + 
                                length(doc_intersect_pairs))
  }

  
  #  corpus metrics   
  precision <- corpus_intersect_pairs / corpus_found_pairs
  recall <- corpus_intersect_pairs / corpus_gold_pairs
  f1_score <- if ((precision + recall) > 0) {
    2 * precision * recall / (precision + recall)
  } else {
    0
  }
  # corpus results
  this_result <- tibble(
    textid = texts_names[t],
    PP_precision = precision,
    PP_recall = recall,
    PP_F_score = f1_score
  )
  PP_eval_results<-bind_rows(PP_eval_results, this_result)
}

#all results
write_csv(PP_eval_results, paste0(evaldir, "PP_eval_results.csv"))

 
