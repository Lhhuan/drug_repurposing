#echo -e "chr1\tstart1\tend1\tchr2\tstart2\tend2\tPathogenicity_score" >../output/Pathogenicity_score_inversion.txt
cat ../../hotspot/inv_svscore | cut -f1,2,3,4,5,6,8 >../output/Pathogenicity_score_inversion.txt
cat ../../hotspot/cnv_svscore |cut -f1,2,3,5  >../output/Pathogenicity_score_cnv.txt
cat ../../hotspot/dup_svscore | cut -f1,2,3,5 >../output/Pathogenicity_score_duplication.txt
cat ../../hotspot/tra_svscore | cut -f1,2,3,4,5,6,8  >../output/Pathogenicity_score_translocation.txt
cat ../../hotspot/del_svscore | cut -f1,2,3,5  >../output/Pathogenicity_score_deletion.txt
