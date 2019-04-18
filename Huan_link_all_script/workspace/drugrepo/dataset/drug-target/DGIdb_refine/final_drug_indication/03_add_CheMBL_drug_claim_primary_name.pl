#在./output/02_dgidb_all_drug_target.txt 的基础上加了drug_chembl_id|drug_claim_primary_name这一列，用drug_chembl_id和drug_claim_primary_name这两个属性进行筛选。有drug_chembl_id的用drug_chembl_id，没有的用drug_claim_primary_name 
#得./output/03_dgidb_all_drug_target.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./output/02_dgidb_all_drug_target.txt";
my $fo = "./output/03_dgidb_all_drug_target.txt";   
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tgene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_primary_name = $f[8];
       my $drug_chembl_id = $f[10];
       if($f[10] !~ /NA|NULL|NONE/){
          my $key3 = "$drug_chembl_id\t$_";
          unless(exists $hash3{$key3}){
              print "$key3\n";
              $hash3{$key3} = 1;
          }
       }
       else{
           my $key4 = "$drug_claim_primary_name\t$_";
           unless(exists $hash4{$key4}){
               print "$key4\n";
               $hash4{$key4} = 1;

           }  
       }
      }
}




close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

