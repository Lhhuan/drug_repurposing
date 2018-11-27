#将interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./interactions_v3.tsv";
my $fi1  ="./Drugbank_drug_indication.txt";
my $fo = "./step1-interactions_v3-uni-drug_database.txt";

open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id|drug_claim_name\tinteraction_claim_source\n";
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
       if($f[8] =~ /NULL|NONE/){  
           my $drug_claim_name = $f[5];
           my $interaction_claim_source = $f[3];
           my $key1 = "$drug_claim_name\t$interaction_claim_source";
           unless(exists $hash1{$key1}){
           print "$key1\n";
           $hash1{$key1} = 1
           } 
       }
       else{
           my $drug_chembl_id = $f[8];
           my $interaction_claim_source = $f[3];
           my $key2 = "$drug_chembl_id\t$interaction_claim_source";
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
   unless(/^ENSGID/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[16];
       my $drug_name = $f[3];
       my $drug_source = $f[15];
       if($f[16] !~ /NA/){
          my $key3 = "$drug_chembl_id\t$drug_source";
          unless(exists $hash3{$key3}){
              print "$key3\n";
              $hash3{$key3} = 1;
          }
       }
       else{
           my $key4 = "$drug_name\t$drug_source";
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

