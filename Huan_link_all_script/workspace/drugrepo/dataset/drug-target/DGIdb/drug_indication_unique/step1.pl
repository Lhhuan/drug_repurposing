#将interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./interactions_v3.tsv";
my $fi1  ="./Drugbank_drug_indication.txt";
my $fo = "./step1-interactions_v3_drug_target_database.txt";   #interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。

open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_name\tdrug_stage\tgene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I>)
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
           print "$key1\n";
           $hash1{$key1} = 1
           } 
       }
       else{
           my $key2 = "$drug_chembl_id\t$drug_stage\t$t";
           unless(exists $hash2{$key2}){
           print "$key2\n";
           $hash2{$key2} = 1; 
          }
       }
   }
}



while(<$I1>)
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
              print "$key3\n";
              $hash3{$key3} = 1;
          }
       }
       else{
           my $key4 = "$drug_claim_name\t$k";
           unless(exists $hash4{$key4}){
               print "$key4\n";
               $hash4{$key4} = 1;

           }  
       }
      }
}




close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $I1 or warn "$0 : failed to close input file '$fi1' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

