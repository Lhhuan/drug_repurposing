
#张老师
perl 01_noncoding.pl
/f/Tools/vep/ensembl-vep-release-89/vep --dir /f/Tools/vep/ensembl-vep-release-89/.vep/ --assembly GRCh37 -i  CosmicNonCodingVariants.vcf  -o CosmicNonCodingVariants.vep.txt --tab  --cache --offline --fork 16  --symbol --gene --total_length
