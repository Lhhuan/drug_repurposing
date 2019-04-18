#用./output/01_merge_all_drug_indications.txt为./output/03_dgidb_all_drug_target.txt中的药物寻找indication，得全部的药物 indication 状态：./output/04_all_drug_indciation.txt
#得有适应症的药物./output/04_drug_known_indication.txt，得没有适应症的药物./output/04_drug_unknown_indication.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./output/01_merge_all_drug_indications.txt";
my $f2 = "./output/03_dgidb_all_drug_target.txt";   
my $fo1 = "./output/04_all_drug_indciation.txt"; 
my $fo2 = "./output/04_drug_known_indication.txt"; 
my $fo3 = "./output/04_drug_unknown_indication.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $header = "drug_chembl_id|drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tgene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id";
$header = "$header\tMax_phase\tFirst_approval_or_approvel\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5);


while(<$I1>)
{
chomp;
    unless(/^drug_chembl_id/){
        my @f = split/\t/;
        my $drug_chembl_id = $f[0];
        my $drug_claim_name =$f[1];
        my $Drug_claim_primary_name = $f[2];
        my $Drug_indication =$f[3];
        my $Indication_class =$f[4];
        my $Max_phase =$f[5];
        my $First_approval_or_approvel = $f[6];
        my $Clinical_phase = $f[7];
        my $Link= $f[8];
        my $Drug_indication_source = $f[9];
        my $v= "$Max_phase\t$First_approval_or_approvel\t$Indication_class\t$Drug_indication\t$Drug_indication_source\t$Clinical_phase\t$Link";
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\//_/g;
        #------------------------------------
        $drug_claim_name =~s/\(.*?$//g;
        $drug_claim_name =uc ($drug_claim_name);
        $drug_claim_name =~ s/"//g;
        $drug_claim_name =~ s/'//g;
        $drug_claim_name =~ s/,//g;
        $drug_claim_name =~ s/\s+//g;
        $drug_claim_name =~s/\&/+/g;
        $drug_claim_name =~s/\)//g;
        $drug_claim_name =~s/\(//g;
        $drug_claim_name =~s/\//_/g;
        unless ($drug_chembl_id =~/NONE|NULL|NA/){
            push @{$hash1{$drug_chembl_id}},$v;
        }
        push @{$hash2{$Drug_claim_primary_name}},$v;
        push @{$hash3{$drug_claim_name}},$v;
    }
}

while(<$I2>)
{
    chomp;
    unless(/^drug_chembl_id/){
        my @f = split/\t/;
        my $drug_chembl_id_drug_claim_primary_name = $f[0];
        my $drug_claim_name =$f[8];
        my $Drug_claim_primary_name =$f[9];
        my $chembl = $f[-1];
    
        #-----------------------------
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\//_/g;
        #------------------------------------
        $drug_claim_name =~s/\(.*?$//g;
        $drug_claim_name =uc ($drug_claim_name);
        $drug_claim_name =~ s/"//g;
        $drug_claim_name =~ s/'//g;
        $drug_claim_name =~ s/,//g;
        $drug_claim_name =~ s/\s+//g;
        $drug_claim_name =~s/\&/+/g;
        $drug_claim_name =~s/\)//g;
        $drug_claim_name =~s/\(//g;
        $drug_claim_name =~s/\//_/g;
        my $k = "$chembl\t$Drug_claim_primary_name\t$drug_claim_name";
        if (exists $hash1{$chembl}){ #先用chembl筛选
            $hash5{$k}=1;
            my @v1s = @{$hash1{$chembl}};
            foreach my $v1(@v1s){
                my $output = "$_\t$v1";
                unless (exists $hash4{$output}){
                    $hash4{$output}=1;
                    print $O1 "$output\n";
                    print $O2 "$output\n";
                }

            }
        }
        
        if (exists $hash2{$Drug_claim_primary_name}){ #再用$Drug_claim_primary_name筛选
            $hash5{$k}=1;
            my @v2s = @{$hash2{$Drug_claim_primary_name}};
            foreach my $v2(@v2s){
                my $output = "$_\t$v2";
                unless (exists $hash4{$output}){
                    $hash4{$output}=1;
                    print $O1 "$output\n";
                    print $O2 "$output\n";
                }
            }
        }
        if (exists $hash3{$drug_claim_name}){ #最后用drug_claim_name筛选
            $hash5{$k}=1;
            my @v3s = @{$hash3{$drug_claim_name}};
            foreach my $v3(@v3s){
                my $output = "$_\t$v3";
                unless (exists $hash4{$output}){
                    $hash4{$output}=1;
                    print $O1 "$output\n";
                    print $O2 "$output\n";
                }
            }
        }
        
        unless(exists $hash5{$k}){#没有indication 的drug
            my $v4 = "NA\tNA\tNA\tNA\tNA\tNA\tNA";
            my $output = "$_\t$v4";
            unless (exists $hash4{$output}){
                $hash4{$output}=1;
                print $O1 "$output\n";
                print $O3 "$output\n";
            }
        }
    }
}



