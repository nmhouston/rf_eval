# Evaluation workflow and materials 
This repo contains the data, scripts, and outputs from evaluating the Rhymefindr method
README with the gold standard annotated rhyme data provided in Reddy and Sonderegger's Chicago Rhyming Poetry Corpus (https://github.com/sravanareddy/rhymedata).

## Repo contents and organization
The folders in the repo match the structure on the computer used to run the R scripts, so directory paths can be easily edited for running the scripts.

(root)
 - README.md  
 - data_memo.md -- details about resolving errors in the gold standard corpus 
 
 - (reddy): Contains the raw data files downloaded from Reddy's repo. See the data memo for details.
	 - (data): Reddy data files output as csv from prepare_reddy_data
	 - (output): rhyme analysis output from find_rhymes_reddy
	 - (eval): outputs from prepare_for_evaluation, evaluate_RK_method, evaluate_Plechac_method, and examine_reddy_data_errors

 - (scripts)  Scripts were run in this order:
	 - prepare_reddy_data (prepare the raw text files as csv)  
	 - find_rhymes_reddy (run Rhymefindr)  
	 - prepare_for_evaluation (combine gold standard and Rhymefindr vectors to use in evaluation scripts)
	 - evaluate_RK_method (compare Rhymefindr results with the gold standard annotations using the methods in Reddy and Knight 2011) 
	 - evaluate_Plechac_method (compare Rhymefindr results with the gold standard annotations using the methods in Plechac 2018)
	 - examine_reddy_data_errors (collect the data records with errors and find their distribution over the chronological periods)  
 


