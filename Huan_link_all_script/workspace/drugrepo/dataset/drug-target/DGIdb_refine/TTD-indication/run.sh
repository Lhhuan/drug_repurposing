perl step1.pl #将interactions中的来自于TTD的部分筛出来，得interactions_v3-TTD.txt，共3050行。
perl step2.pl #将step1中得到的结果interactions_v3-TTD.txt与来自"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-indication/TTD-old/Result_TTDdrugid_drugname_disease.txt"
#根据TTD的drugid进行匹配，得到gene-drug-indication的关系，得文件step2_result_TTD-gene-indication,共3325行。