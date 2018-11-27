#将21_all_drug_infos.txt和normal_DGIDB_drug_target_score.txt中的target score merge到一起，得all_drug_infos_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./21_all_drug_infos.txt"; 
my $f2 ="./normal_DGIDB_drug_target_score.txt"; 
my $fo1 ="./all_drug_infos_score.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";
$title = "$title\tdrug_target_score";
print $O1 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Drug_chembl_id = $f[0];
         my $symbol = $f[2];
         my $k = "$Drug_chembl_id\t$symbol";
         push @{$hash1{$k}},$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Drug_chembl_id = $f[0];
         my $symbol = $f[1];
         my $drug_target_score = $f[3];
         my $k = "$Drug_chembl_id\t$symbol";
         $hash2{$k}= $drug_target_score;
     }
}






foreach my $drug (sort keys %hash1){ #这里的$drug是指"$Drug_chembl_id\t$symbol"
    if (exists $hash2{$drug}){
        my @drug_infos = @{$hash1{$drug}};
        my $score = $hash2{$drug};
        foreach my $drug_info(@drug_infos){
            my $output1 = "$drug_info\t$score";
            unless(exists $hash3{$output1}){
                print $O1 "$output1\n";
            }
        }
    }
    else{
        my @drug_infos = @{$hash1{$drug}};
        foreach my $drug_info(@drug_infos){
            print $O1 "$drug_info\tNA\n";
        }
    }
}
