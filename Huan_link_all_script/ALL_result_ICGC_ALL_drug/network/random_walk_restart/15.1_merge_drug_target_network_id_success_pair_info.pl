#用../output/04_map_ICGC_snv_indel_in_network_num.txt把./output/12_ICGC_snv_indel_network_drug_indication_cancer.txt.gz 中的 drug entrze id 转化成在网络中的编号。
#得./output/15.1_merge_drug_target_network_id_success_pair_info.txt.gz
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./output/12_ICGC_snv_indel_network_drug_indication_cancer.txt.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
my $f2 ="../output/04_map_ICGC_snv_indel_in_network_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/15.1_merge_drug_target_network_id_success_pair_info.txt.gz"; 
open my $O1, "| gzip >$fo1" or die $!;
my $header ="drug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tENSG_ID\tDrug_type\tdrug_target_score\tdrug_target_network_id";
print $O1 "$header\n";



my (%hash1,%hash2,%hash3,%hash4);



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^entrezgene/){  #entrezgene和network_id转换
        my $gene = $f[0];
        my $network_id = $f[1];
        $hash2{$gene}=$network_id;
    }
}

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug_name_network/){
        my $Entrez_id = $f[22];
        if (exists $hash2{$Entrez_id}){
            my $drug_target_network_id = $hash2{$Entrez_id};
            print $O1 "$_\t$drug_target_network_id\n";
        }
    }
}


# foreach my $drug (sort keys %hash1){
#     my @infos = @{$hash2{$drug}};
#     foreach my $info(@infos){
#         print $O1 "$info\n";
#     }
# }


