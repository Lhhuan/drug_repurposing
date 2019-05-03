zcat ./output/simple_somatic_mutation.aggregated.vcf.gz | perl -ane '{next if($_ =~ /^#/); my @info_array = split(/;/,$F[7]); foreach my $i (@info_array){if($i =~ /^affected_donors/){my @a_affected = split(/\=/,$i);if($a_affected[1] >0){print $_}}} }' > ./output/simple_somatic_mutation.largethan0.vcf 
wc -l ./output/simple_somatic_mutation.largethan0.vcf #881782588
#比v27 多4320298个位点
gzip ./output/simple_somatic_mutation.largethan0.vcf

vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i ./output/simple_somatic_mutation.aggregated.vcf.gz --cache --offline -o ./output/simple_somatic_mutation.all_vep.vcf --nearest gene --fork 30  --symbol --gene --total_length --hgvs --hgvsg --protein --biotype --distance 500,0