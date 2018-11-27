#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step13_chembl_exist.txt";
my $fo1 = "./step14_chembl_exist_indication.txt";  #有indication的数据
my $fo2 = "./step14_chembl_unexist_phase_0.txt"; #没有indication的信息，但是max_phase > 0
my $fo3 = "./step14_chembl_unexist_phase=0.txt";  #没有indication的信息，并且max_phase=0
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\n";
select $O2;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\n";
select $O3;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\n";
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
       my $max_phase = $f[4];
       my $first_approval = $f[5];
       my $indication_class = $f[6];
       if($indication_class !~ /\\N/){ #筛选出$indication_class不为空的数据
           unless(exists$hash1{$_}){
                print $O1 "$_\n";
                $hash1{$_} = 1;
           }
       }
       elsif($max_phase > 0){ #筛选出max_phase不为0的数据
           unless(exists$hash2{$_}){
                print $O2 "$_\n";
                $hash2{$_} = 1;
           }
       }
       else {   #筛选出max_phase为0的数据
           unless(exists$hash3{$_}){
                print $O3 "$_\n";
                $hash3{$_} = 1;
           }
       }
   }
}

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";

