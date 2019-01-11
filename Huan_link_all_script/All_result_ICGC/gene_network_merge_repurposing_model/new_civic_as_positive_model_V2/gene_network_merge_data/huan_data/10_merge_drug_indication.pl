#将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt"中的indication和./output/09_repurposing_Drug_claim_primary_name.txt merge 到一起，
#得 ./output/10_merge_drug_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt";
my $f2 ="./output/09_repurposing_Drug_claim_primary_name.txt";
my $fo1 ="./output/10_merge_drug_indication.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^the_shortest_path/){
       my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
       my $Max_phase =$f[6];
       my $First_approval = $f[7];
       my $Drug_indication_Indication_class = $f[13];
       my $indication_OncoTree_detail_ID = $f[-3];
       my $indication_OncoTree_main_ID =$f[-1];
       my $v = "$Max_phase\t$First_approval\t$Drug_indication_Indication_class\t$indication_OncoTree_detail_ID\t$indication_OncoTree_main_ID";
       push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v;
        
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $Drug_claim_primary_name = $f[0];
    my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
    my $cancer_oncotree_id = $f[2];
    my $cancer_oncotree_id_type =$f[3];
    my $predict = $f[-2];
    my $predict_value = $f[-1];
    my $out1 = "$Drug_claim_primary_name\t$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id\t$cancer_oncotree_id_type\t$predict\t$predict_value" ;

    if(/^Drug_claim_primary_name/){
        print $O1 "$out1\tMax_phase\tFirst_approval\tDrug_indication_Indication_class\tindication_OncoTree_detail_ID\tindication_OncoTree_main_ID\n";
    }
    else{
       if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my @drug_infos = @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}};
            my %hash5;
            @drug_infos = grep { ++$hash5{$_} < 2 } @drug_infos;
            foreach my $drug_info(@drug_infos){
                my $output = "$out1\t$drug_info";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
       }
       else{
           print STDERR "$Drug_chembl_id_Drug_claim_primary_name\n";
       }
    }
}

