#将./output/21_all_drug_infos.txt和./output/from_sinan_score.txt中的target score merge到一起，得./output/all_drug_infos_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/21_all_drug_infos.txt"; 
my $f2 ="./output/from_sinan_score.txt"; 
my $fo1 ="./output/all_drug_infos_score.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Drug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";  
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
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
         my $symbol = $f[1];
         $symbol =~s/"//g;
         $symbol =uc($symbol);
         my $k = "$Drug_chembl_id\t$symbol";
         push @{$hash1{$k}},$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){ #21_all_drug_infos.txt中Drug_chembl_id和$symbol均为大写
        for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
            unless(defined $f[$i]){
                $f[$i] = "NONE";
            }
        }
         my $Drug_chembl_id = $f[0];
        #  $Drug_chembl_id = uc($Drug_chembl_id);
         my $symbol = $f[4];
         $symbol =~s/"//g;
         $symbol =uc($symbol);
         my $drug_target_score = $f[7];
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
        # print STDERR "$drug\n";
        my @drug_infos = @{$hash1{$drug}};
        foreach my $drug_info(@drug_infos){
            print $O1 "$drug_info\tNA\n";
        }
    }
}
