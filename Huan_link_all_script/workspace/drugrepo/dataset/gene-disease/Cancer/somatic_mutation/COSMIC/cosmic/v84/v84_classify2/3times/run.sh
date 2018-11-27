perl 01_codingthan2.pl
perl 01_noncodingthan2.pl
/f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_largethan2_nm.vcf  -o CosmicNonCodingVariants_largethan2_nm_vep.vcf --cache --offline --fork 8  --symbol --gene --total_length
/f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm.vcf  -o CosmicCodingMuts_largethan2_nm_vep.vcf --cache --offline --fork 14  --symbol --gene --total_length
perl 02_merge_all_coding_and_noncoding.pl
perl 02_merge_all_coding_and_noncoding_mutayion_id.pl #因为一个mutation对应多个mutation id,对每个>2的mutation的mutation 进行提取。 得All_cosmic_Muts_mutation_id_largethan2_nm.vcf
perl 03_connect_vep_vcf.pl
perl 04_revel.pl
cat cosmic_revel_score.txt | perl -ane '{next if($_ =~ /^chr/);@f = split/\t/;if ($f[3]>=0.5){print "$f[0]\t$f[3]\n"}}' | sort -u > unique_largethan0.5_revel_score.txt
cat cosmic_revel_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if ($f[3]<0.5){print "$_\n"}}' | sort -u > smallthan0.5_revel_score.txt
cat smallthan0.5_revel_score.txt | perl -ane 'chomp; {next if($_ =~ /^chr/); @f = split/\t/; print "$f[0]\t$f[4]\t$f[5]\t$f[6]\t$f[7]\n"}' | sort -u > cosmic_all_no_revel_score.txt
cat cosmic_no_revel_score.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u >> cosmic_all_no_revel_score.txt
perl 05_spzdex.pl
cat cosmic_spzdex_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if($f[1] >= 0){print "$f[0]\t$f[1]\t$f[2]\n"; }}' | sort -u > unique_spzdex_score_largethan0.txt
cat cosmic_spzdex_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/;if($f[1] <0){print "$f[0]\t$f[3]\t$f[4]\t$f[5]\t$f[6]\n"; } }' | sort -u > spzdex_score_smallthan0.txt
cat spzdex_score_smallthan0.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u > cosmic_all_no_spzdex_score.txt
cat cosmic_no_spzdex_score.txt | perl -ane 'chomp;{next if($_ =~ /^chr/);print "$_\n"}' | sort -u >> cosmic_all_no_spzdex_score.txt
perl 06_mannal_filter.pl
cat unique_largethan0.5_revel_score.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u > cosmic_all_coding_path.txt
cat unique_spzdex_score_largethan0.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >> cosmic_all_coding_path.txt
cat cosmic_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >> cosmic_all_coding_path.txt
cat cosmic_all_coding_path.txt | sort -u >cosmic_all_uni_coding_path.txt
perl 07_filter_occur.pl
cat cosmic_true_no_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; unless($f[0]=~/MT/){print "$_\n"}}' | sort -u >cosmic_true_filter_no_mannal.txt
cat cosmic_true_filter_no_mannal.txt | perl -ane 'chomp; unless(/^chr/){@f = split/\t/; print "$f[0]\n"}' | sort -u >unique_no_coding_path.txt