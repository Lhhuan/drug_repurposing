#将"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt"中的indication和./output/06_drug_cancer_prediction_potential_drug_repurposing.txt
#merge 到一起，得./output/07_merge_drug_cancer_prediction_potential_drug_repurposing_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt";
my $f2 ="./output/06_drug_cancer_prediction_potential_drug_repurposing.txt";
my $fo1 ="./output/07_merge_drug_cancer_prediction_potential_drug_repurposing_indication.txt"; 
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
       my $indication_OncoTree_main_ID =$f[-1];
       my $v = "$Max_phase\t$First_approval\t$indication_OncoTree_main_ID";
    #    my $v = "$indication_OncoTree_main_ID";
       push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v;
        
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\tMax_phase\tFirst_approval\tindication_OncoTree_main_ID\n";
    }
    else{
       my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
       if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my @drug_infos = @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}};
            my %hash5;
            @drug_infos = grep { ++$hash5{$_} < 2 } @drug_infos;
            foreach my $drug_info(@drug_infos){
                my $output = "$_\t$drug_info";
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

