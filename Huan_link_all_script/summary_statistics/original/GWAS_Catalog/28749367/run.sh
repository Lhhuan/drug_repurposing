for k in $(seq 1 5)
do 
    wget -c ftp://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GondaliaR_28749367_GCST004642/Fixed_Effects_METAL_Results_Part${k}.zip
done
zcat Fixed_Effects_METAL_Results_Part*.zip > Fixed_Effects_METAL_Results_Part.txt
cp Fixed_Effects_METAL_Results_Part.txt 28749367_QT_interval_\(ambient_particulate_matter_interaction\).txt