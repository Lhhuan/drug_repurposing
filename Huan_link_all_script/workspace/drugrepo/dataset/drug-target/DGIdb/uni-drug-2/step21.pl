#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi1 ="./step20_drug-indication-exist.txt";
my $fi3 ="./step19_drug_no_indication-mannal-3.txt";
my $fo1 = "./step21_drug-indication-unexist.txt"; #最后一步得

open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi1' : $!\n";
#open my $I2, '<', $fi2 or die "$0 : failed to open input file '$fi2' : $!\n";
open my $I3, '<', $fi3 or die "$0 : failed to open input file '$fi3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print"drug_chembl_id\n";
my (%hash1,%hash2, %hash3);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       $hash1{$drug_chembl_id}= 1;
   }
}


while(<$I3>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       for (my $i=0;$i<14;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       if($f[1] =~/NULL/){ #因为成盐或者其他原因有一个药物有两个chemle_id，而另一个chembl_id在drugbank中有indication的药物（这部分药物属于重复）直接丢掉了
           my $drug_chembl_id = $f[0];
           $hash2{$drug_chembl_id}= 1;
             
           }
       }
}


foreach my $drug_chembl_id(sort keys %hash2){
       unless(exists $hash1{$drug_chembl_id}){ 
             $hash2{$drug_chembl_id}= 1;
                    unless(exists $hash3{$drug_chembl_id}){
                        print $O1 "$drug_chembl_id\n";
                        $hash3{$drug_chembl_id} = 1;
                    }   
        }
}

