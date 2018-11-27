#把19_ICGC_Indel_SNV_repo-may_success_logic_true.txt 的drug， repo cancer 和logic输出得20_drug_repo_cancer_logic_true.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./19_ICGC_Indel_SNV_repo-may_success_logic_true.txt";
my $fo1 ="./20_drug_repo_cancer_logic_true.txt"; 
my $fo2 ="./20_lable.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "oncotree_ID\tDrug_chembl_id\tDrug_claim_primary_name\n";
print $O2 "name\tlabel\n";




my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
      my $cancer = $f[11];
      my $Drug_chembl_id =$f[13];
      $Drug_chembl_id =~s/"//g;
      my $Drug_claim_primary_name= $f[20];
      $Drug_claim_primary_name =~s/"//g;
      #my $logic =$f[-1];
      my $out1 = "$cancer\t$Drug_chembl_id\t$Drug_claim_primary_name";
      unless(exists $hash1{$out1}){
          $hash1{$out1} =1 ;
          print $O1 "$out1\n";
      }
      my $out2 = "$cancer\tcancer";
      my $out3 = "$Drug_claim_primary_name\tdrug";
      unless(exists $hash2{$out2}){
          $hash2{$out2} =1 ;
          print $O2 "$out2\n";
      }
      unless(exists $hash2{$out3}){
          $hash2{$out3} =1 ;
          print $O2 "$out3\n";
      }


     }
}


