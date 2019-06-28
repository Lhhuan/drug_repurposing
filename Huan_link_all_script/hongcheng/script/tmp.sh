perl 01_transform_dbNSFP_snv_to_vcf.pl 
echo -e "finish_01_transform_dbNSFP_snv_to_vcf\n"
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i ../output/01_dbNSFP_snv.vcf.gz --cache --offline -o ../output/01_dbNSFP_snv_vep_huan.vcf --fork 40 --uniprot --gene --symbol --biotype
vep --dir /f/mulinlab/huan/tools/vep/ensembl-vep-release-93/.vep/ --assembly GRCh37  -i ../output/01_dbNSFP_snv.vcf.gz --cache --offline -o ../output/01_dbNSFP_snv_vep.vcf --uniprot --symbol --gene --fork 30 --hgvs --hgvsg --protein --




