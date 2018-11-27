#########此脚本中中的统计数字为上一版本，此版本的数字需具体统计。
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/interactions_v3.tsv"  interactions_v3.tsv
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/step4_drugbank_drug_gene_entrez_id.txt" Drugbank_drug_indication.txt
perl step1.pl #将interactions_v3.tsv中的drug进行unique,如果chemblID为空的行，用$drug_claim_name进行unique，把interactions_v3.tsv中没有的drugbank的数据也通过chemleid或者drugname纳入进来，得到文件step1-interactions_v3_drug_target_database.txt
perl step2.pl #在step1的基础上加了drug_chembl_id|drug_claim_primary_name这一列，用drug_chembl_id和drug_claim_primary_name这两个属性进行筛选。有drug_chembl_id的用drug_chembl_id，没有的用drug_claim_primary_name, 
    # 得文件step2-interactions_v3_drug_target_database.txt。此得drug-target的所有信息
perl step3.pl #用文件step2-interactions_v3_drug_target_database.txt的第一列进行去重。得文件step3-uni-drug.txt得到药物14220行。
perl step4.pl ###用文件chembl_molecules.txt对文件step2-interactions_v3_drug_target_database.txt进行进一步的信息补充。得文件step4_interactions_v3_drug_target_indication_database.txt。
perl step4-1.pl #用step4_interactions_v3_drug_target_indication_database.txt 按照drug_chembl_id|drug_claim_name这一列去重复，得到药物14412个。
    #(这里的总数和uni-drug-2中总数不一样的原因是：这里的drugbank中的drug_claim_name是指的原来表里的source_id，即drugbank-id,而uni-drug-2中drugbank的drug_claim_name是指原来表里的drug_name。)
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/drugs.txt" drugs.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/drug_claims.txt" drug_claims.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/chembl_molecules.txt" chembl_molecules.txt
#下面为uni-drug-2收集到的drug_indication
#--------------------------------------------------------
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step5_all_drug_indication1.txt" uni-drug-2-step5_all_drug_indication1.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step5_all_drug_indication2.txt" uni-drug-2-step5_all_drug_indication2.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step7_drug_indication.txt"   uni-drug-2-step7_drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step9_drug_indication.txt"  uni-drug-2-step9_drug_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step10_drug_indication2.txt"  uni-drug-2-step10_drug_indication2.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step10_drug_indication1.txt" uni-drug-2-step10_drug_indication1.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step13-1_drug-indication-exist.txt" uni-drug-2-step13-1_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14_chembl_exist_indication.txt" uni-drug-2-step14_chembl_exist_indication.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14-1_drug-indication-exist.txt" uni-drug-2-step14-1_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step14-2_drug-indication-exist.txt" uni-drug-2-step14-2_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step15_drug-indication-exist.txt"  uni-drug-2-step15_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step16_drug-indication-exist.txt"  uni-drug-2-step16_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step17_drug-indication-exist.txt"  uni-drug-2-step17_drug-indication-exist.txt
cp "/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DGIdb/uni-drug-2/step20_drug-indication-exist.txt"  uni-drug-2-step20_drug-indication-exist.txt
#-------------------------------------------------------------------------------------
perl step5.pl #把以上cp 过来的14个drug-indication文件统一格式得文件step5_all_drug_indication.txt。
perl step6.pl #将文件step5_all_drug_indication.txt和文件step4_interactions_v3_drug_target_indication_database.txt交叉查询，得到_target_drug_indication的整个表的信息，为文件step6_target_drug_indication.txt
     #没有indication的drug文件为step6_no_indication_drug.txt 
perl step8.pl #发现step6_no_indication_drug.txt有indication-class,将这一部分筛出，与step6_target_drug_indication1.txt合并得step8_target_drug_indication.txt
    #得没有indication的drug文件为step8_no_indication_drug.txt
perl step9.pl #用drug_chembl_id|drug_claim_name这一列对step8_no_indication_drug.txt进行去重，得文件step9-unique-drug_no_indication.txt共有8305个药物没有indication。  用Drug_chembl_id|Drug_claim_primary_name进行unique得药物8250个。
#这里面包括一部分重复的。用
perl step9-1.pl #用drug_chembl_id|drug_claim_name对step8_target_drug_indication.txt进行unique得文件step9-1-unique-drug，有6107个drug,如果用drug_chembl_id|drug_claim_primary_name这一列unique,得到药物5994个。
perl step10.pl #将step8_target_drug_indication.txt 中MOA不为空的，Drug_indication这一列中没有值的，输出Indication_class，生成一列新数据Drug_indication|Indication_class。
#得文件step10_all_target_drug_indication_MOA.txt的信息。有 4917个药物。 得文件没有drug没有moa的文件step10_all_target_drug_indication_no_MOA.txt 有3369个药物。4917+3369=8286>6107,
 #说明两个文件中有重复的，一部分药物存在于文件step10_all_target_drug_indication_MOA.txt中，且存在于step10_all_target_drug_indication_no_MOA.txt的药物应该有8286-6107= 2179个药物。没有drug-moa的药物实际上为3369-2179= 1190个。
perl step10-1.pl #没有drug-moa的药物实际上为3369-2179= 1190个,把这1190个提出来。
          #得step10-1_target_drug_indication_moa_repetition.txt为 drug_indication的信息在step10_all_target_drug_indication_MOA.txt重复，但是没有moa,unique 后drug有2179个，符合预期。
          #得step10-1_target_drug_indication_no-moa_unique.txt为 没有moa的药物信息，有unique的药物1190个。
perl step10-2.pl #将文件step10-1_target_drug_indication_no-moa_unique.txt中FDAapproval的药物筛选出来。
         #得文件fda认证的药物step10-2_target_drug_indication_no-moa_unique_fda.txt unique后，有121个药物。
         #得文件不是fda认证的药物step10-2_target_drug_indication_no-moa_unique_nofda.txt，unique 后，得到1069个药物。
perl step10-3.pl #将step8_target_drug_indication.txt 中Drug_indication这一列中没有值的，输出Indication_class，生成一列新数据Drug_indication|Indication_class。得文件step10-3_all_target_drug_indication.txt 。
perl step10-4.pl #将step10-3_all_target_drug_indication.txt的indication提出，并去重得step10-4_unique_indication.txt ，将该文件进行mapin 共有unique的indication 5121个。

cat step10-3_all_target_drug_indication.txt | perl -ane 'chomp;my @f = split/\t/;print "$f[5]\n";' |sort -u > uni_Entrez_id.txt
Rscript 01.2_mygene_tf2_entrez_id-ensg.R #将entrez_id 转为ensg ID，得文件transform.txt
perl deal_tranfrom_gene.pl #对transform.txt的一些字符进行一些处理，得文件dgidb_symbol-ENSG_ID.txt

cat step1-interactions_v3_drug_target_database.txt | perl -ane 'chomp;@f =split/\t/;my $interaction_claim_source =$f[5];my $drug_claim_name=$f[7]; unless(/^drug_chembl_id/){if($interaction_claim_source=~/Drugbank/){print "$drug_claim_name\n"}}'| sort -u |wc -l #5051


cat step6_target_drug_indication.txt | perl -ane 'chomp;@f =split/\t/;my $interaction_claim_source =$f[6];my $drug_claim_name=$f[8]; unless(/^drug_chembl_id/){if($interaction_claim_source=~/Drugbank/){print "$drug_claim_name\n"}}'| sort -u |wc -l