#examine_reddy_data_errors_202502
#collect the records with errors found in the Reddy data files and find 
#their distribution over the chronological periods

library(tidyverse)
library(fs)
datadir<-"C:/data/JCLS2025/reddy/data/"
evaldir<-"C:/data/JCLS2025/reddy/eval/"
texts_paths<-path_filter(dir_ls(evaldir), glob="*_error.csv")
texts_names<-path_ext_remove(path_file(texts_paths))
texts_prefix<-str_remove_all(texts_names, "_error")

num_stanzas<-double(length=length(texts_names))
num_errors<-double(length=length(texts_names))

combined_errors<-tibble(
  fileid=character(),
  textid=double(),
  poem=character(),
  endwords=character(),
  goldvector=character(),
  rfnum=character(),
  ltrvec=character(),
  perf=character(),
  throw_out=double()
)
for (i in 1:length(texts_names)){
  errors<-read_csv(paste0(evaldir, texts_names[i], ".csv"))
  reddy<-read_csv(paste0(datadir, texts_prefix[i], ".csv"))

  errors <-errors %>% 
    mutate(fileid=texts_prefix[i]) %>%
    relocate(fileid, .before=textid)

  num_stanzas[i]<-length(reddy$textid)
  num_errors[i]<-length(errors$textid)
  
  if (length(errors$textid) > 0){
      combined_errors<-bind_rows(combined_errors, errors)
  }
}

write_csv(combined_errors, paste0(evaldir, "combined_errors.csv"))

error_ratio<-tibble(textid=texts_prefix,
                    num_stanzas=num_stanzas,
                    num_errors=num_errors
                    )

write_csv(error_ratio, paste0(evaldir, "error_ratio.csv")) 

##percent errors in the Reddy data
sum(error_ratio$num_stanzas) #11611
sum(error_ratio$num_errors) #98
sum(error_ratio$num_errors)/sum(error_ratio$num_stanzas) #0.00844