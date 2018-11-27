wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/RafflerJ_26352407_GCST003119/mGWAS_urine_SHIP-0_associations.zip
unzip mGWAS_urine_SHIP-0_associations.zip 
cat ./resultsdownload/results_single_nontargeted_for_gwasserver_download.txt ./resultsdownload/results_single_targeted_for_gwasserver_download.txt > 26352407_Urinary_metabolites.txt