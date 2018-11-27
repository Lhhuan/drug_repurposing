#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./interactions_v3-TEND.txt";
my $fi_indication = "./nrd3478-s1-TEND.txt";
my $fi_drug_indication = "./step2_result_drug_indication.txt";
my $fi_unmatch = "./step2_unmatch_drug.txt";
#my $fo = "./interactions_v3-TTD.txt";

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $O1, '>', $fi_drug_indication or die "$0 : failed to open output file '$fi_drug_indication' : $!\n";
open my $O2, '>', $fi_unmatch or die "$0 : failed to open output file '$fi_unmatch' : $!\n";
select $O1;
print "gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\tdrug_claim_name\tIndication\tYear_of_Approval\n";
select $O2;
print "drug_claim_name\n";

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
           unless($f[5] eq "NONE"){
               my ($drug_claim_primary_name, $drug_name)= ($f[6], $f[7]);
               my $drug_claim_name = $f[5];
               my $t = join"\t",@f[0..4,6..8];
               push @{$hash1{$drug_claim_name}},$t;      
       }
   }
}



while(<$I2>)
{
   chomp;
   unless(/^Drug/){
        my @f = split/\t/;
        my ($drug_Name, $Indication, $Year_of_Approval) = ($f[0], $f[1], $f[2]);
        my $k = join"\t",@f[1,2];
        push @{$hash2{$drug_Name}},$k;
        }
}

 foreach my $drug_claim_name(sort keys %hash1){
       if(exists $hash2{$drug_claim_name}){ 
            my @t = @{$hash1{$drug_claim_name}};
            my @k = @{$hash2{$drug_claim_name}};
             foreach my $t(@t){
                foreach my $k(@k){
                    my $key = "$t\t$drug_claim_name\t$k";
               #my $key = $drug_claim_name;
                    unless(exists $hash3{$key}){
                        print  $O1 "$key\n";
                        $hash3{$key} = 1;
                 }
            }
        }
   }
     else {
         unless (exists $hash4{$drug_claim_name}){
         print $O2 "$drug_claim_name\n";
         $hash4{$drug_claim_name} = 1;
         }
     }
 }



