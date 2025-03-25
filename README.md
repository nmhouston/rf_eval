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
	 - (eval): outputs from evaluate_reddy, examine_reddy_data_errors, and accuracy_reddy  
	 - (output): rhyme analysis output from find_rhymes_reddy

 - (scripts)  Scripts were run in this order:

	- prepare_reddy_data_202502 (prepare the text files as csv)  
	 - find_rhymes_reddy_202502 (run Rhymefindr)  
	 - evaluate_reddy_202502 (compare the Rhymefindr results with the gold standard annotations)  
	 - examine_reddy_data_errors_202502 (collect the data records with errors and find their distribution over the chronological periods)  
	 - accuracy_reddy_202502 (calculate mean accuracy for each chronological file) 


