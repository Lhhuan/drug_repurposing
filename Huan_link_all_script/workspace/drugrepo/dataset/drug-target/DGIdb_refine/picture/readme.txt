cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step8_no_indication_drug.txt" all_no_indication_drug.txt
有14412个
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/drug_indication_unique/step9-unique-drug_no_indication.txt" unique_no_indication.txt
复制no_indication_drug和unique_no_indication的文件

unique_no_indication.txt 共有8305个。

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step13_chembl_unexist.txt" chembl_unexist.txt 
复制没有chembl id的文件，有3593个。

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step12_drug_unmatch_indication_in_drugbank-expri.txt"  indication_in_drugbank-expri.txt
得在drugbank中处于drugbank的文件  有2685个。

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14-2_drug_no_indication.txt" clinical_phase0.txt
得处于phase0阶段药物的文件，有 1850个

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step19_drug_no_indication.txt" mannal_no_indication.txt
得手动也没找到indication的文件，有243行。

cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step21_drug-indication-unexist.txt" clinical_no_indication.txt
得在clinical中也找不到indication的文件 ，有 143个。

step1_filter_drugbank.pl 筛选all_no_indication_drug.txt文件中drug gene interaction 源于drugbank的药物，得在drugbank中处于实验阶段的文件step1_in_drugbank-expri.txt， 有2614个。
    
    和不是drugbank中exper的文件step1_out_drugbank_or_un-expri.txt

step2_filter_chembl.pl 筛选step1_out_drugbank.txt中没有chembl的文件
 得没有chembl id 的文件step2_no_chembl.txt, 共3585行。
 得有chembl 得文件step2_chembl.txt 

 step3_filter_phase0.pl 筛选step2_chembl.txt文件中 phase0的文件。
   得药物是phase0的文件step3_phase0.txt 得处于phase0阶段药物的文件，有1879个
   得药物不是phase0的文件step3_no_phase0.txt

cat step3_no_phase0.txt | perl -ane 'chomp; unless(/^Drug_chembl_id/){@f=split/\t/;print "$f[1]\n";}' | sort -u >final_unique_no_indication.txt
 404个这里面有重复的，其实应该剩203个。

画图数据：共有药物14412个 。有indication的药物有6107个，没有indication的药物有8305个。
  其中8305个中包括：2614个源于drugbank中处于experience阶段的药物;
                   3585个源于没有chembl id;
                   1879个源于max phase处于0;
                   227个是手动很难找到的。
                   


step4_filter_repeat_no_indication.pl
将在step3_no_phase0.txt中存在，并且在以上三个文件中也存在的数据筛选掉。