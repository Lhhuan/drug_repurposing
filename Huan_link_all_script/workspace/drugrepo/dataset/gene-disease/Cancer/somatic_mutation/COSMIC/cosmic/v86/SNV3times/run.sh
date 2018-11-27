nohup  vep --dir /f/mulinlab/huan/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm_indel.vcf  -o CosmicCodingMuts_largethan2_nm_indel_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length > nohup.out &
nohup  vep --dir /f/mulinlab/huan/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm_indel.vcf  -o CosmicCodingMuts_largethan2_nm_indel_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length  --hgvs --hgvsg --protein --biotype --nearest  > nohup.out &


nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants_largethan2_nm.vcf  -o CosmicNonCodingVariants_largethan2_nm_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length > nohup.out &

nohup  /f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicCodingMuts_largethan2_nm_indel.vcf  -o CosmicCodingMuts_largethan2_nm_indel_vep.vcf --cache --offline --fork 20  --symbol --gene --total_length  --hgvs --hgvsg --protein --biotype --nearest  > nohup.out &