#将./output/interactions_v3.tsv 和./output/Drugbank_drug_indication.txt merge 到一起，得02_dgidb_all_drug_target.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./output/interactions_v3.tsv";
my $f2  ="./output/Drugbank_drug_indication.txt";
my $fo = "./output/02_dgidb_all_drug_target.txt";   #interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
print $O1 "drug_chembl_id|drug_claim_name\tdrug_stage\tgene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       my $gene_name = $f[0];
       my $gene_claim_name = $f[1];
       my $entrez_id = $f[2];
       my $interaction_claim_source = $f[3];
       my $interaction_types = $f[4];
       my $drug_claim_name = $f[5];
       my $drug_claim_primary_name = $f[6];
       my $drug_name = $f[7];
       my $drug_chembl_id = $f[8];
       my $drug_stage = "unknown";
       my $t = join"\t",@f[0..8]; 
       if($f[8] =~ /NULL|NONE/){  
           my $key1 = "$drug_claim_name\t$drug_stage\t$t";
           unless(exists $hash1{$key1}){
           print $O1 "$key1\n";
           $hash1{$key1} = 1
           } 
       }
       else{
           my $key2 = "$drug_chembl_id\t$drug_stage\t$t";
           unless(exists $hash2{$key2}){
           print $O1 "$key2\n";
           $hash2{$key2} = 1; 
          }
       }
   }
}



while(<$I2>)
{
   chomp;
   unless(/^entrez_id/){
       my @f = split/\t/;
       my $gene_name = "unknown";
       my $gene_claim_name = "unknown";
       my $entrez_id = $f[0];
       my $interaction_claim_source = $f[16]; #原来表里的source_database;
       my $interaction_types = $f[7];
       my $drug_claim_name= $f[14]; #原来表里的source_id
       my $drug_claim_primary_name = $f[4]; #原来表里的drug_name
       my $drug_name = "unknown";
       my $drug_chembl_id = $f[17];
       my $drug_stage = $f[9];
       my $k ="$drug_stage\t$gene_name\t$gene_claim_name\t$entrez_id\t$interaction_claim_source\t$interaction_types\t$drug_claim_name\t$drug_claim_primary_name\t$drug_name\t$drug_chembl_id";
       if($f[17] !~ /NA/){
          my $key3 = "$drug_chembl_id\t$k";
          unless(exists $hash3{$key3}){
              print $O1 "$key3\n";
              $hash3{$key3} = 1;
          }
       }
       else{
           my $key4 = "$drug_claim_name\t$k";
           unless(exists $hash4{$key4}){
               print $O1 "$key4\n";
               $hash4{$key4} = 1;
           }  
       }
      }
}

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo' : $!\n";

