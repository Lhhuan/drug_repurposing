#把./output/02_Sensitivity_clinical_significance_oncotree.txt中是药物联用的行去掉，得./output/03_single_drug_treat_cancer.txt,drug和 "/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"里的
#drug取overlap，得overlap 文件./output/03_unique_overlap_drug.txt。得没有overlap的文件，./output/03_unique_not_overlap_drug.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 ="./output/02_Sensitivity_clinical_significance_oncotree.txt";
my $fo1 ="./output/03_single_drug_treat_cancer.txt";
my $fo2 ="./output/03_unique_overlap_drug.txt";
my $fo3 ="./output/03_unique_not_overlap_drug.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\n";
print  $O2 "drug\tdrug_rename\n";
print  $O3 "drug\tdrug_rename\n";



while(<$I1>)
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
        $hash1{$Drug_claim_primary_name}= $Drug_chembl_id_Drug_claim_primary_name;
    }
}



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
        my $oncotree_term_detail = $f[0];
        my $oncotree_ID = join ("\t",@f[0..3]);
        my $drug = $f[4];
        unless($drug =~/,/){
            my $output = "$oncotree_ID\t$drug";
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
            my $drug_rename = $drug;
            $drug_rename =~s/\(.*?$//g;
            $drug_rename =uc($drug_rename);
            $drug_rename =~ s/"//g;
            $drug_rename =~ s/'//g;
            $drug_rename =~ s/\s+//g;
            $drug_rename =~ s/,//g;
            $drug_rename =~s/\&//g;
            $drug_rename =~s/\+//g;
            $drug_rename =~s/\(.*?//g;
            $drug_rename =~s/\)//g;
            $drug_rename =~s/\//_/g;
            if (exists $hash1{$drug_rename}){
                my $output2 = "$drug\t$drug_rename";
                unless(exists $hash3{$output2}){
                    $hash3{$output2} =1;
                    print $O2 "$output2\n";
                }
            }
            else{
                my $output2 = "$drug";
                unless(exists $hash3{$output2}){
                    $hash3{$output2} =1;
                    print $O3 "$output2\n";
                }               
            }
        }
    }
}



close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
