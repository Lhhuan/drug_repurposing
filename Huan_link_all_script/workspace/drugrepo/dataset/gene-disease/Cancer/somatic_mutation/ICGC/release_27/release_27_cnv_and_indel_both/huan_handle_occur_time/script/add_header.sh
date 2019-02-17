echo -e "chr1\tstart1\tend1\tchr2\tstart2\tend2\toccur_time" >../output/occur_time_inversion.txt
cat ../../occur_time/inversion | cut -f1,2,3,4,5,6,8 | sort -k7,7g >>../output/occur_time_inversion.txt
echo -e "chr\tstart\tend\toccur_time\tcnv_type" >../output/occur_time_cnv.txt
cat ../../occur_time/cnv | sort -k4,4g >>../output/occur_time_cnv.txt
echo -e "chr\tstart\tend\toccur_time" >../output/occur_time_duplication.txt
cat ../../occur_time/duplication | cut -f1,2,3,4 | sort -k4,4g>>../output/occur_time_duplication.txt
echo -e "chr1\tstart1\tend1\tchr2\tstart2\tend2\toccur_time" >../output/occur_time_translocation.txt
cat ../../occur_time/translocation | cut -f1,2,3,4,5,6,8 | sort -k7,7g >>../output/occur_time_translocation.txt
echo -e "chr\tstart\tend\toccur_time" >../output/occur_time_deletion.txt
cat ../../occur_time/deletion | cut -f1,2,3,4 | sort -k4,4g >>../output/occur_time_deletion.txt
#提取文件特定列并给文件添加header