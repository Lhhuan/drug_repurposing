#检查在./output/03_unique_drug.txt的drug在"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"中存在，并调出./output/03_single_drug_treat_cancer.txt中的cancer信息，得./output/04_drug_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./output/03_single_drug_treat_cancer.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f3 ="./output/03_unique_drug.txt";
my $fo1 ="./output/04_drug_cancer.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my (%hash1,%hash2,%hash3,%hash4,%hash5);
print  $O1 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
        my $oncotree_ID = join ("\t",@f[0..3]);
        my $drug = $f[4];
        push @{$hash1{$drug}},$oncotree_ID;
    }
}





while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Drug_claim_primary_name = $f[4];
        $Drug_claim_primary_name =uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~s/\&//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $hash2{$Drug_claim_primary_name}= $Drug_chembl_id_Drug_claim_primary_name;
        $hash3{$Drug_chembl_id_Drug_claim_primary_name} =1;
    }
}



while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless (/^drug/){
        my $drug = $f[0];
        my $drug_rename = $f[1];
        $drug_rename =~ s/"//g;
        $drug_rename =~ s/'//g;
        $drug_rename =~ s/\s+//g;
        $drug_rename =~ s/,//g;
        $drug_rename =~s/\&//g;
        $drug_rename =~s/\+//g;
        $drug_rename =~s/\)//g;
        $drug_rename =~s/\(//g;
        $drug_rename =~s/\//_/g;
        if(exists $hash1{$drug}){
            my @oncotree_IDs = @{$hash1{$drug}};
            unless($drug_rename=~/NA/){
                if(exists $hash2{$drug_rename}){ #首先用$Drug_claim_primary_name匹配
                    foreach my $oncotree_ID (@oncotree_IDs){
                        my $out1 = "$oncotree_ID\t$drug";
                        unless(exists $hash4{$out1}){
                            $hash4{$out1} =1;
                            print $O1 "$out1\n";
                        }
                    } 
                }
                elsif(exists $hash3{$drug_rename}){ #再用$Drug_chembl_id_Drug_claim_primary_name匹配
                    foreach my $oncotree_ID (@oncotree_IDs){
                        my $out1 = "$oncotree_ID\t$drug";
                        unless(exists $hash4{$out1}){
                            $hash4{$out1} =1;
                            print $O1 "$out1\n";
                        }
                    } 
                }
            }
        }    
        else{
            print  STDERR  "$drug\n";
        }
    }
}



close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
