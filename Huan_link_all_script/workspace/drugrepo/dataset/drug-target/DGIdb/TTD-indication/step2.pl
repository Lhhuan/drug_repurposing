#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./interactions_v3-TTD.txt";
my $fi_indication = "./Result_TTDdrugid_drugname_disease.txt";
#my $fo = "./interactions_v3-TTD.txt";

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
#open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
 my (%hash1,%hash2);
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
           unless($f[5] eq "NONE"){
               my ($drug_claim_primary_name, $drug_name)= ($f[6], $f[7]);
               my $drug_id = $f[5];
               my $t = join"\t",@f[0..4,6..8];
               push @{$hash1{$drug_id}},$t;      
       }
   }
}



while(<$I2>)
{
   chomp;
   unless(/^TTDdrug_id/){
        my @f = split/\t/;
        my ($TTDdrug_id, $drug_name, $disease) = ($f[0], $f[1], $f[2]);
        my $k = join"\t",@f[1,2];
        push @{$hash2{$TTDdrug_id}},$k;
       
        }
}

 foreach my $drug_id(sort keys %hash1){
       if(exists $hash2{$drug_id}){ 
            my @t = @{$hash1{$drug_id}};
            my @k = @{$hash2{$drug_id}};
             foreach my $t(@t){
                foreach my $k(@k){
                print "$t\t$drug_id\t$k\n"
            }
        }
   }
 }



