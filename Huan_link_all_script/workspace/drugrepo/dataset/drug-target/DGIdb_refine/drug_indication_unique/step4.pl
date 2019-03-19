#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#在chembl_molecules.txt对文件step2-interactions_v3_drug_target_database.txt进行tmax_phase\tfirst_approval\tindication_class的信息补充。
my $f1 ="./step2-interactions_v3_drug_target_database.txt";
my $f2 = "./chembl_molecules.txt";
my $fo1 = "./step4_interactions_v3_drug_target_indication_database.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "drug_chembl_id|drug_claim_primary_name\tdrug_chembl_id|drug_claim_name\tdrug_stage\tgene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name";
select $O1;
print "$header\tdrug_name\tdrug_chembl_id\tmax_phase\tfirst_approval\tindication_class\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_chembl_id_drug_claim_primary_name = $f[0];
       my $key1 = $drug_chembl_id_drug_claim_primary_name; 
       push @{$hash1{$key1}},$_;
       #print "$_\n";

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
      # print "$v2\n";
   }
}

 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ 
            my @v1 = @{$hash1{$key1}};
            my $v2 = $hash2{$key1};
            foreach my $v1(@v1){
                my $key3 = "$v1\t$v2";
                unless(exists $hash3{$key3}){
                    print "$key3\n";
                    $hash3{$key3} = 1;
               }
            }
       }
       else {
           my @v1 = @{$hash1{$key1}};
            foreach my $v1(@v1){
                my $key4 = "$v1\tunknown\tunknown\tunknown";#不存在chembl_id的药物的tmax_phase\tfirst_approval\tindication_class信息，用unknown填写。
                unless(exists $hash4{$key4}){
              print "$key4\n";
              $hash4{$key4} = 1;
               }
            }
       }
 }         
close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";