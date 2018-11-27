#wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/SolerArtigas/SpiroMeta_1000G_FEV1_50Neff_filt_results.txt.gz
gzip -cd SpiroMeta_1000G_FEV1_50Neff_filt_results.txt.gz > SpiroMeta_1000G_FEV1_50Neff_filt_results.txt
cp SpiroMeta_1000G_FEV1_50Neff_filt_results.txt 26635082_forced_expiratory_volume_in_1s_\(FEV1\).txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/SolerArtigas/SpiroMeta_1000G_FVC_50Neff_filt_results.txt.gz
gzip -cd SpiroMeta_1000G_FVC_50Neff_filt_results.txt.gz > SpiroMeta_1000G_FVC_50Neff_filt_results.txt
cp SpiroMeta_1000G_FVC_50Neff_filt_results.txt 26635082_forced_vital_capacity\(FVC\).txt
wget -c https://grasp.nhlbi.nih.gov/downloads/ResultsOctober2016/SolerArtigas/SpiroMeta_1000G_FEV1overFVC_50Neff_filt_results.txt.gz
gzip -cd SpiroMeta_1000G_FEV1overFVC_50Neff_filt_results.txt.gz > SpiroMeta_1000G_FEV1overFVC_50Neff_filt_results.txt
cp SpiroMeta_1000G_FEV1overFVC_50Neff_filt_results.txt 26635082_forced_expiratory_volume_in_1s\(FEV1\)\/forced_vital_capacity\(FVC\).txt