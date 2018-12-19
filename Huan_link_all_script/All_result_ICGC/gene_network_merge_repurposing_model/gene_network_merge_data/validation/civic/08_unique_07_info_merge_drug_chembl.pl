#利用"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 给./output/07_unique_mutation_drug_cancer_pair.txt和加一列Drug_chembl,
#./output/08_unique_mutation_Drug_chembl_cancer_pair.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 ="./output/07_unique_mutation_drug_cancer_pair.txt";
my $fo1 ="./output/08_unique_mutation_Drug_chembl_cancer_pair.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Drug_claim_primary_name =$f[4];
        $Drug_claim_primary_name =uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~s/\&//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $hash1{$Drug_claim_primary_name} = $Drug_chembl_id_Drug_claim_primary_name;
    }
}




while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if (/^Mutation_ID/){
        print $O1 "Drug_chembl_id_Drug_claim_primary_name\t$_\n";
    }
    else{
        my $Mutation_ID =$f[0];
        my $oncotree_main_tissue_id =$f[2];
        my $drug= $f[3];
        $drug =uc($drug);
        $drug =~ s/"//g;
        $drug =~ s/'//g;
        $drug =~ s/\s+//g;
        $drug =~ s/,//g;
        $drug =~s/\&//g;
        $drug =~s/\+//g;
        $drug =~s/\)//g;
        $drug =~s/\//_/g;
        if(exists $hash1{$drug}){
            my $Drug_chembl_id_Drug_claim_primary_name = $hash1{$drug};
            my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$_";
            print $O1 "$output\n";
        }
        else{
            my $Drug_chembl_id_Drug_claim_primary_name = "NA";
            my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$_";
            print $O1 "$output\n";
        }
    }
}





close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄