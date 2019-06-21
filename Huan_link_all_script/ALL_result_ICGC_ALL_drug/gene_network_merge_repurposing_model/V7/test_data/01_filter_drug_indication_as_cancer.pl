#把"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt" 治疗cancer，且一行的indication中只有一个cancer的，并且是phase4或者Approved 的 drug cancer作为正样本。
#得./output/01_drug_cancer_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt";
my $fo1 ="./output/01_drug_cancer_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tsample_type\tdrug_repurposing";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug_claim_primary_name = $f[4];
        my $Max_phase =$f[6];
        my $First_approval = $f[7];
        my $Clinical_phase= $f[11];
        my $indication_OncoTree_main_ID = $f[-2];
        my $indication_OncoTree_main_term = $f[-3];
        my $indication_OncoTree_IDs_detail = $f[-4];
        my $indication_OncoTree_term_detail = $f[-5];
        # my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$Max_phase\t$First_approval\t$Clinical_phase\t$indication_OncoTree_main_ID";
        my $sample_type= "positive";
        my $drug_repurposing = "1";
        my $output ="$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID\t$Drug_claim_primary_name\t$sample_type\t$drug_repurposing";
        unless($indication_OncoTree_term_detail =~/NA|Unmatch|;/){
            if ($Max_phase =~/\b4|Launched|Approved\b/){
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
            elsif($Clinical_phase =~/4|Launched/){
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}
