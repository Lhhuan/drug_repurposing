wget  http://www.gefos.org/sites/default/files/GEFOS2_LSBMD_POOLED_GC.txt.gz 
gzip -cd GEFOS2_LSBMD_POOLED_GC.txt.gz > GEFOS2_LSBMD_POOLED_GC.txt
cp GEFOS2_LSBMD_POOLED_GC.txt 22504420_Lumbar_spine_bone_mineral_density.txt
wget http://www.gefos.org/sites/default/files/GEFOS2_FNBMD_POOLED_GC.txt.gz
gzip -cd GEFOS2_FNBMD_POOLED_GC.txt.gz >  GEFOS2_FNBMD_POOLED_GC.txt
cp GEFOS2_FNBMD_POOLED_GC.txt 22504420_Femoral_neck_bone_mineral_density.txt