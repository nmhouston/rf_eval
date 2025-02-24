# Evaluation data memo

## Gold standard data files 
For this evaluation, I used the english_gold files containing stanza end words and numerical vectors of rhyme annotations provided in the repo for Reddy and Sonderegger's Chicago Rhyming Poetry Corpus (https://github.com/sravanareddy/rhymedata), which was the data used in Reddy and Knight 2011. Their repo presents this annotation data in two formats, organized by chronological period or by author.  

I used the five chronological files, which are the files analyzed in Reddy and Knight 2011. These files compile the data records for several individual authors into one file per period:
 - 1415.pgold
 - 1516.pgold
 - 1617.pgold
 - 1718.pgold 
 - 1819.pgold 
 
Each record in these files represents a stanza of a poem. Each contains:
 - a tag comprising the word POEM plus a numerical code
 - the sequence of end words in that stanza
 - a numerical vector representing the rhyme scheme of the stanza 
 - a numerical vector representing the rhyme scheme of the stanza in the context of the poem (this would differ from the other vector if words in the given stanza share rhymes with a previous stanza)
 
Unfortunately, the POEM tags used in the corpus are not distinctively numbered for different texts (the numbering restarts at zero for each poet), so each chronological file contains records for stanzas from several different poems that are all labeled "POEM0".  

## Data preparation and naming conventions
To work with the raw text files downloaded from the Reddy repo, I renamed them as .txt files and changed the dot to an underscore, so 1415.pgold became 1415_pgold.txt. I followed this naming convention throughout the workflow so that each transformation or analysis can be easily linked with related files. 

## Errors discovered in the gold standard corpus
While working with this data, I discovered errors in 101 entries in the Reddy and Sonderegger gold standard corpus, which comprises 11613 entries representing individual stanzas from poems. I was able to edit one entry and had to remove 100 of them from my evaluation because it was unclear what the correct data should be for those entries.  

### Entries modified in the initial text files 
While running the text preparation script (prepare_reddy_data_202502), I discovered errors in the 1617_pgold and 1718_pgold files that would prevent accurate parsing into columns. To correct those errors, I removed two entries and edited a third to be able to process the data files. 

 - 1617_pgold
	 - deleted incomplete entry from lines 7041-7044
	 - original file renamed 1617_pgold_original.txt
	 - edited file named 1617_pgold.txt used for evaluation 

 - 1718_pgold
	 - deleted incomplete entry from lines 3677-3680
	 - edited line 7281 to begin with POEM8 
	 - original file renamed 1718_pgold_original.txt
	 - edited file named 1718_pgold.txt used for evaluation 
 
### Entries removed from the evaluation 
In running the evaluation script (evaluate_reddy_202502), I discovered that 98 of the remaining 11611 entries in the gold standard annotated data contained errors in which the number of stanza end words is different from the number of rhyme positions listed in the vector. I removed those 98 entries from the evaluation and examined them in examine_reddy_data_errors_202502, which outputs the following files: 

 - The error_ratio csv shows the distribution of the entries with errors (56 in 1617_pgold, 8 in 1718_pgold, and 34 in 1819_pgold) and the total number of stanzas in each chronological file. 
 - The combined_errors csv contains the erroneous entries, keyed to their source file. 
 
 Although it might be possible to find the source files for these stanzas in the raw poem files provided by Reddy and Sonderegger and input the missing rhyme annotations, they do not provide their encoding guidelines for resolving ambiguous rhyme matches and so such a reconstruction might compromise the integrity of their dataset. 

