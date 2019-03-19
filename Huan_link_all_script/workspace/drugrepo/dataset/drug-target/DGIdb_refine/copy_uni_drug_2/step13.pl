#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step12_drug_unmatch_indication_out_drugbank.txt";
my $f2 = "./chembl_molecules.txt";
my $fo1 = "./step13_chembl_exist.txt";  #在chembl_molecules.txt中存在的step12_drug_unmatch_indication_out_drugbank.txt
my $fo2 = "./step13_chembl_unexist.txt"; #在chembl_molecules.txt中不存在的step12_drug_unmatch_indication_out_drugbank.txt
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\n";
select $O2;
print"drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_stage = $f[1];
       my $interaction_type = $f[2];
       my $interaction_claim_source = $f[3];
       my $v1 = "$drug_stage\t$interaction_type\t$interaction_claim_source";
       $hash1{$drug_chembl_id}=$v1;
   }
}

while(<$I2>)
{
   chomp;
   if(/\d+/){
       my @f = split/\t/;
       for (my $i=0;$i<28;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       my $drug_chembl_id = $f[3];
       my $max_phase = $f[4];
       my $first_approval = $f[10];
       my $indication_class = $f[26];
       my $v2 = "$max_phase\t$first_approval\t$indication_class";
       $hash2{$drug_chembl_id}=$v2;
   }
}

 foreach my $drug_chembl_id(sort keys %hash1){
       if(exists $hash2{$drug_chembl_id}){ 
            my $v1 = $hash1{$drug_chembl_id};
            my $v2 = $hash2{$drug_chembl_id};
            my $k3 = "$drug_chembl_id\t$v1\t$v2";
            unless(exists$hash3{$k3}){
                print $O1 "$k3\n";
                $hash3{$k3} = 1;
            }
       }
       else {
           my $v1 = $hash1{$drug_chembl_id}; 
           my $k4 = "$drug_chembl_id\t$v1";
           unless(exists$hash4{$k4}){#看$v1在hash4是否存在
                print $O2 "$k4\n";
                $hash4{$k4} = 1;
            }
       }
 }         
close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

