cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/3times/cosmic_all_uni_coding_path.txt"  cosmic_coding_path.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/v84_classify2/3times/Cosmic_all_ref_alt.txt" Cosmic_all_ref_alt.txt
perl 01_connect_coding_point_to_vep.pl
perl 02_filter_feature.pl 手动去重
Rscript  OncodriveROLE.R
perl 03_classify_coding_path_info.pl
perl 04_classify_coding_path_moa.pl
