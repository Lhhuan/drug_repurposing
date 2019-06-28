#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt"把./output/06_mutation_network_drug_indication_cancer.txt.gz中的 drug entrze id 转化成在网络中的编号。
#得./output/07_merge_drug_target_network_id_success_pair_info.txt.gz
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  


my $f1 ="./output/06_mutation_network_drug_indication_cancer.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
my $f2 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/07_merge_drug_target_network_id_success_pair_info.txt.gz"; 
open my $O1, "| gzip >$fo1" or die $!;
my $header= "network_drug_name\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P"; #network
$header = "$header\tcancer_entrez"; #
$header = "$header\tVariant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tCancer_Entrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule"; #mutation
$header= "$header\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tdrug_target_Entrez_id\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tClinical_phase\tDrug_indication_Indication_class\tIndication_ID";
$header= "$header\tDrug_type\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score\tPACTIVITY_median";
$header = "$header\tdrug_target_network_id";
print $O1 "$header\n";



my (%hash1,%hash2,%hash3,%hash4);



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^gene_symbol/){  #entrezgene和network_id转换
        my $gene = $f[1];
        my $network_id = $f[2];
        $hash2{$gene}=$network_id;
    }
}

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name_network/){
        my $Entrez_id = $f[18];
        if (exists $hash2{$Entrez_id}){
            my $drug_target_network_id = $hash2{$Entrez_id};
            print $O1 "$_\t$drug_target_network_id\n";
            # print "$Entrez_id\t$drug_target_network_id\n";
        }
    }
}



