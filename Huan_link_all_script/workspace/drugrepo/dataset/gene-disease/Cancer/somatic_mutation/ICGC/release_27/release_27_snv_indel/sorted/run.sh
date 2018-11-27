/f/Tools/bcftools/bcftools-1.3.1/bcftools view -v snps VannoDB_DA_ICGC_r27.vcf.gz  -O z -o VannoDB_DA_ICGC_r27_snp.vcf.gz
/f/Tools/bcftools/bcftools-1.3.1/bcftools view -v indels VannoDB_DA_ICGC_r27.vcf.gz  -O z -o VannoDB_DA_ICGC_r27_indel.vcf.gz

zcat  VannoDB_DA_ICGC_r27_snp.vcf.gz  VannoDB_DA_ICGC_r27_indel.vcf.gz >all_varint.vcf  
wc -l all_varint.vcf #77019173   77462290

zcat VannoDB_DA_ICGC_r27_indel.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >0){print $_}}} }' > VannoDB_DA_ICGC_r27_indel_largethan0.vcf
zcat VannoDB_DA_ICGC_r27_indel.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >1){print $_}}} }' > VannoDB_DA_ICGC_r27_indel_largethan1.vcf
zcat VannoDB_DA_ICGC_r27_indel.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >2){print $_}}} }' > VannoDB_DA_ICGC_r27_indel_largethan2.vcf
zcat VannoDB_DA_ICGC_r27_indel.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >3){print $_}}} }' > VannoDB_DA_ICGC_r27_indel_largethan3.vcf
wc -l VannoDB_DA_ICGC_r27_indel_largethan0.vcf #6289701
wc -l VannoDB_DA_ICGC_r27_indel_largethan1.vcf #1129716
wc -l VannoDB_DA_ICGC_r27_indel_largethan2.vcf #478948
wc -l VannoDB_DA_ICGC_r27_indel_largethan3.vcf #257213

zcat simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >0){print $_}}} }' > simple_somatic_mutation.largethan0.vcf