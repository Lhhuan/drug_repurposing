#将interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./interactions_v3.tsv";
my $fi1  ="./drugbank_drug_gene_entrez_id.txt";
my $fo = "./statistic-drug_gene.txt";

open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_name\tentrez_id|gene_claim_name\tinteraction_types\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

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
       my $gene_claim_name = $f[1];
       my $entrez_id = $f[2];
       my $drug_claim_name = $f[5];
       my $interaction_types = $f[4];
       my $drug_chembl_id = $f[8];
       if($f[8] =~ /NULL|NONE/){  
           if($f[2] =~ /NULL|NONE/){ 
               my $key1 = "$drug_claim_name\t$gene_claim_name\t$interaction_types";
               unless(exists $hash1{$key1}){
                   print "$key1\n";
                   $hash1{$key1} = 1
               }
           }
           else{
               my $key2 = "$drug_claim_name\t$entrez_id\t$interaction_types";
               unless(exists $hash2{$key2}){
                   print "$key2\n";
                   $hash2{$key2} = 1;
           }
           
         }
       }
       else{
           my $drug_chembl_id = $f[8];
           my $interaction_claim_source = $f[3];
           my $interaction_types = $f[4];
           my $drug_stage = "unknown";
           if($f[2] =~ /NULL|NONE/){ 
               my $key3 = "$drug_chembl_id\t$gene_claim_name\t$interaction_types";
               unless(exists $hash3{$key3}){
                   print "$key3\n";
                   $hash3{$key3} = 1
               }
           }
           else{
               my $key4 = "$drug_chembl_id\t$entrez_id\t$interaction_types";
               unless(exists $hash4{$key4}){
                   print "$key4\n";
                   $hash4{$key4} = 1;
               }
           }
       }
   }
}



while(<$I1>)
{
   chomp;
   unless(/^ENSGID/){
       my @f = split/\t/;
       my $entrez_id = $f[0];
       my $ensg_id = $f[1];
       my $drug_chembl_id = $f[17];
       my $drug_name = $f[4];
       my $drug_source = $f[16];
       my $interaction_types = $f[7];
       my $drug_stage = $f[9];
       if($f[17] !~ /NA/){
          my $key5 = "$drug_chembl_id\t$entrez_id\t$interaction_types";
          unless(exists $hash5{$key5}){
              print "$key5\n";
              $hash5{$key5} = 1;
          }
       }
       else{
           my $key6 = "$drug_name\t$entrez_id\t$interaction_types";
           unless(exists $hash6{$key6}){
               print "$key6\n";
               $hash6{$key6} = 1;

           }  
       }
      }
}




close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $I1 or warn "$0 : failed to close input file '$fi1' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

