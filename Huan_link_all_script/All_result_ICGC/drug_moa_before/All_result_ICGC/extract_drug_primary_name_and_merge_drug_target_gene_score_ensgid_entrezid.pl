#在huan_target_drug_indication_final_symbol.txt中提取normal_DGIDB_drug_target_score.txt 的Drug_chembl_id|Drug_claim_primary_name所对应的Drug_claim_primary_name
#并将tranfrom_dgidb_target_score_symbol_ensgid_entrezid.txt和normal_DGIDB_drug_target_score.txt merge成一个文件。得drug_target_score_symbol_ensgid_entrezid.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_final_symbol.txt"; 
my $f2 ="./normal_DGIDB_drug_target_score.txt"; 
my $f3 ="./tranfrom_dgidb_target_score_symbol_ensgid_entrezid.txt"; 
my $fo1 ="./drug_target_score_symbol_ensgid_entrezid.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez_ID\tprimary\tsecondary\n"; 

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
         my $Drug_claim_primary_name =$f[8];
         $Drug_claim_primary_name = lc($Drug_claim_primary_name);
         $hash2{$Drug_chembl_id_Drug_claim_primary_name},$Drug_claim_primary_name;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Drug_claim_primary_name = $f[0];
         my $gene =$f[1];
         my $moa = $f[2];
         my $score = $f[3];
         $Drug_claim_primary_name = lc($Drug_claim_primary_name);
         $hash2{$Drug_chembl_id_Drug_claim_primary_name},$Drug_claim_primary_name;
     }
}




foreach my $drug (sort keys %hash1){
    if (exists $hash2{$drug}){
        my @diseases = @{$hash1{$drug}};
        my @genes = @{$hash2{$drug}};
        foreach my $disease(@diseases){
            my @f= split/\t/,$disease;
            my $primary = $f[0];
            my $secondary = $f[1];
            foreach my $gene(@genes){
                my @t= split/\t/,$gene;
                my $symbol = $t[0];
                my $entrez = $t[1];
                my $out1= "$drug\t$symbol\t$entrez\t$primary\t$secondary";
                unless(exists $hash3{$out1}){
                    print $O1 "$out1\n";
                    $hash3{$out1}=1;
                }
            }
        }
    }
    else{
        my $out2 = $drug;
        unless(exists $hash4{$out2}){
            print $O2 "$out2\n";
            $hash4{$out2}=1;
        }
    }
}
