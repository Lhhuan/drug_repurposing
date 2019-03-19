#将Drugbank_drug_indication.txt、GuideToPharmacology-drug_indication.txt、chembl_indication.txt、chembl_molecules.txt、chembl_indications-17_13-38-29.txt
#TTD_indication.txt、clinical.trial-drug-indication.txt、TdgClinicalTrial_source_indication.txt、TEND.txt、drugcentral_drug_indication.txt 合并得01_merge_all_drug_indications.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#把搜集到的drug-indication合在一个表里。

my $f1 ="./output/Drugbank_drug_indication.txt";
my $f2 ="./output/GuideToPharmacology-drug_indication.txt";
my $f3 ="./output/chembl_indication.txt"; #from chembl postgresql
my $f4 ="./output/chembl_molecules.txt"; #from DGidb
my $f5 ="./output/chembl_indications-17_13-38-29.txt"; #from chembl
my $f6 ="./output/TTD_indication.txt";
my $f7 ="./output/clinical.trial-drug-indication.txt"; #from clincal.trial
my $f8 ="./output/TdgClinicalTrial_source_indication.txt";
my $f9 ="./output/TEND.txt";
my $f10 ="./output/drugcentral_drug_indication.txt";
my $fo1 = "./output/01_merge_all_drug_indications.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $I7, '<', $f7 or die "$0 : failed to open input file '$f7' : $!\n";
open my $I8, '<', $f8 or die "$0 : failed to open input file '$f8' : $!\n";
open my $I9, '<', $f9 or die "$0 : failed to open input file '$f9' : $!\n";
open my $I10, '<', $f10 or die "$0 : failed to open input file '$f10' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "drug_chembl_id\tdrug_claim_name\tdrug_claim_primary_name\tdrug_indication\tindication_class\tMax_phase\tFirst_approval_or_approvel\tClinical_phase\tLink|Refs\tindication_source\n";

my %hash1;

while(<$I1>)
{
   chomp;
   unless(/^entrez_id/){
       my @f = split/\t/;
       if ($f[10] !~ /NA/){ #不读入drugbank中没有indication的数据。
           my $drug_claim_primary_name = $f[4];
           my $best_level = $f[9];
           my $drug_indication = $f[10];
           my $drug_claim_name = $f[14];
           my $interaction_claim_source = $f[16];
           my $drug_chembl_id = $f[17];
           my $indication_class ="NA";
           my $First_approval = "NA";
           my $Clinical_phase = "NA";
           my $link = $f[-3];
           my $indication_source = "DrugBank";
           my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$best_level\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
           unless(exists $hash1{$k}){
               $hash1{$k} = 1;
               print $O1 "$k\n";
           }
       }
   }
}

while(<$I2>)
{
   chomp;
   unless(/^gene_name/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[5];
        my $drug_chembl_id = $f[7];
        my $drug_claim_name = $f[8];
        my $drug_indication = $f[9];
        my $indication_class ="NA";
        my $Max_phase ="NA";
        my $First_approval = "NA";
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = $f[3];
       my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
       unless(exists $hash1{$k}){
           $hash1{$k} = 1;
            print $O1 "$k\n";
       }
   }
}

while(<$I3>)
{
   chomp;
   unless(/^drugind_id/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[8];
        my $drug_chembl_id = $f[9];
        my $drug_claim_name = $f[9];
        my $MESH_ID = $f[3];
        my $MESH_heading = $f[4];
        my $EFO_ID = $f[5];
        my $EFO_NAME = $f[6];
        my $drug_indication = "$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME"; 
        my $indication_class ="NA";
        my $Max_phase ="NA";
        my $First_approval = "NA";
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = "ChEMBL";
       my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
       unless(exists $hash1{$k}){
           $hash1{$k} = 1;
            print $O1 "$k\n";
       }
   }
}


while(<$I4>)
{
   chomp;
   if(/\d+/){
       my @f = split/\t/;
       for (my $i=0;$i<28;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
            unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       my $drug_chembl_id = $f[3];
       my $drug_claim_name = "NA";
       my $drug_claim_primary_name ="NA";
       my $drug_indication ="NA";
       my $Max_phase = $f[4];
       my $First_approval = $f[10];
       my $indication_class = $f[26];
       my $Clinical_phase = "NA";
       my $link = "NA";
       my $indication_source ="DGIdb";
       unless ($indication_class=~/\bNULL|NONE\b/){
           unless($indication_class =~/\\N/){
                my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
                unless(exists $hash1{$k}){
                    $hash1{$k} = 1;
                        print $O1 "$k\n";
                }
            }
       }
   }
}

while(<$I5>)
{
   chomp;
   unless(/^MOLECULE_CHEMBL_ID/){
        my @f = split/\t/;
        for (my $i=0;$i<11;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
        my $drug_chembl_id = $f[0];
        my $drug_claim_primary_name = $f[1];
        my $drug_claim_name = $drug_chembl_id;
        my $MESH_ID = $f[4];
        my $MESH_heading = $f[5];
        my $EFO_ID = $f[6];
        my $EFO_NAME = $f[7];
        my $drug_indication = "$MESH_ID||$MESH_heading||$EFO_ID||$EFO_NAME"; 
        my $indication_class ="NA";
        my $Max_phase =$f[8];
        my $First_approval = $f[3];
        my $Clinical_phase = "NA";
        my $link = $f[10];
        my $indication_source = "ChEMBL";
        my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
        unless(exists $hash1{$k}){
           $hash1{$k} = 1;
            print $O1 "$k\n";
        }
    }
}

while(<$I6>)
{
   chomp;
   unless(/^TTDdrug_id/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[1];
        my $Max_phase = "NA";
        my $drug_indication = $f[2];
        my $drug_claim_name = $f[0];
        my $drug_chembl_id = "NA";
        my $indication_class ="NA";
        my $First_approval = "NA";
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = "TTD";
        my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
        unless(exists $hash1{$k}){
            $hash1{$k} = 1;
            print $O1 "$k\n";
        }
   }
}

while(<$I7>)
{
   chomp;
    my @f = split/\t/;
    my $drug_claim_primary_name = $f[3];
    my $Max_phase = "NA";
    my $drug_indication = $f[5];
    my $drug_claim_name = $f[3];
    my $drug_chembl_id = "NA";
    my $indication_class ="NA";
    my $First_approval = "NA";
    my $Clinical_phase = $f[2];
    my $link = $f[0];
    my $indication_source = "Clinical.trial";
    my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
    unless(exists $hash1{$k}){
        $hash1{$k} = 1;
        print $O1 "$k\n";
    }
}

while(<$I8>)
{
   chomp;
   unless(/^INDEX/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[2];
        my $Max_phase = "NA";
        my $drug_indication = $f[3];
        my $drug_claim_name = $f[2];
        my $drug_chembl_id = "NA";
        my $indication_class ="NA";
        my $First_approval = $f[5];
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = "TdgClinicalTrial";
        my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
        unless(exists $hash1{$k}){
            $hash1{$k} = 1;
            print $O1 "$k\n";
        }
   }
}

while(<$I9>)
{
   chomp;
   unless(/^Drug/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[0];
        my $Max_phase = "NA";
        my $drug_indication = $f[1];
        my $drug_claim_name = $f[0];
        my $drug_chembl_id = "NA";
        my $indication_class ="NA";
        my $First_approval = $f[2];
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = "TEND";
        my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
        unless(exists $hash1{$k}){
            $hash1{$k} = 1;
            print $O1 "$k\n";
        }
   }
}

while(<$I10>)
{
   chomp;
   unless(/^struct/){
        my @f = split/\t/;
        my $drug_claim_primary_name = $f[1];
        my $Max_phase = "NA";
        my $drug_indication = $f[3];
        my $drug_claim_name = $f[1];
        my $drug_chembl_id = "NA";
        my $indication_class ="NA";
        my $First_approval = "NA";
        my $Clinical_phase = "NA";
        my $link = "NA";
        my $indication_source = "Drugcentral";
        my $k = "$drug_chembl_id\t$drug_claim_name\t$drug_claim_primary_name\t$drug_indication\t$indication_class\t$Max_phase\t$First_approval\t$Clinical_phase\t$link\t$indication_source";
        unless(exists $hash1{$k}){
            $hash1{$k} = 1;
            print $O1 "$k\n";
        }
   }
}
