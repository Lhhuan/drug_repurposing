#检查把drugbank 药物更新后，相比于之前多的数据。即用huan_target_drug_indication_final_symbol.txt检查比check_DGIDB_drug_target_score.txt多出的药物。得new_drug_need_find_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./huan_target_drug_indication_final_symbol.txt";
my $f2 = "./check_DGIDB_drug_target_score.txt";
my $fo1 = "./new_drug_need_find_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id|Drug_claim_primary_name/){
        my $drug_name =$f[0];
        $drug_name =~ s/\"//g;
        my $v = join ("\t",@f[7..10]);
        $hash1{$drug_name} =$v;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id|Drug_claim_primary_name/){
        my $drug =$f[0];
        my $gene = $f[1];
        my $moa = $f[2];
        my $score = $f[3];
        my $chembl = $f[4];
        if($drug=~/^CHEMBL/){
            $hash2{$drug}=1
        }
        else{
            if($chembl=~/^CHEMBL/){
                $hash2{$chembl}=1
            }
            else{
                $hash2{$drug}=1
            }
        }
    }
}

foreach my $drug (sort keys %hash1){
    unless(exists $hash2{$drug} ){
        my $v =$hash1{$drug};
        print $O1 "$drug\t$v\n";
    }
}



