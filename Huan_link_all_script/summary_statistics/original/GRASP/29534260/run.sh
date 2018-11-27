

wget -c https://grasp.nhlbi.nih.gov/downloads/FullResults/2017/2017_Kim_Plantar_fasciitis/PlantarSummary.txt.zip
gzip -cd PlantarSummary.txt.zip > PlantarSummary.txt
cp PlantarSummary.txt 29534260_Plantar_fasciitis.txt