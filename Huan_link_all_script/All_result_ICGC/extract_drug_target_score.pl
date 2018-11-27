#把all_drug_infos_score.txt 中的Drug_claim_primary_name,Entrez_id,Drug_type, drug_target_score，得brief_drug_target_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./brief_drug_target_info.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


print $O1 "Entrez_id\tDrug_claim_primary_name\tDrug_type\tdrug_target_score\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Entrez_id = $f[2];
         my $Drug_claim_primary_name =$f[4];
         $Drug_claim_primary_name = lc($Drug_claim_primary_name); #把drug name 都转成小写。
         my $Drug_type = $f[17];
         my $drug_target_score = $f[-1];
         my $output = "$Entrez_id\t$Drug_claim_primary_name\t$Drug_type\t$drug_target_score";
         unless($hash1{$output}){
             $hash1{$output}=1;
             print $O1 "$output\n";
         }
     }
}

