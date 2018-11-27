wget http://www.gefos.org/sites/default/files/fa2stu.MAF0_.005.pos_.out_.gz
gzip -cd  fa2stu.MAF0_.005.pos_.out_.gz > fa2stu.MAF0_.005.pos_.out
cp fa2stu.MAF0_.005.pos_.out 26367794_Forearm_Bone_mineral_density.txt
wget http://www.gefos.org/sites/default/files/ls2stu.MAF0_.005.pos_.out_.gz 
gzip -cd ls2stu.MAF0_.005.pos_.out_.gz > ls2stu.MAF0_.005.pos_.out
cp ls2stu.MAF0_.005.pos_.out 26367794_Lumbar_Spine_bone_mineral_density.txt
wget http://www.gefos.org/sites/default/files/fn2stu.MAF0_.005.pos_.out_.gz
gzip -cd fn2stu.MAF0_.005.pos_.out_.gz > fn2stu.MAF0_.005.pos_.out
cp fn2stu.MAF0_.005.pos_.out 26367794_Femoral_Neck_bone_mineral_density.txt