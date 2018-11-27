#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step5_all_drug_unmatch_indication.txt";
my $f2 = "./clinical.trial-drug-indication.txt";
my $fo1 = "./step7_drug_indication.txt";
my $fo2 = "./step7_drug_unmatch_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print"drug_claim_name\tinteraction_claim_source\tdrug_indication\tphase\tNCDid\tdrug_indication_source\n";
select $O2;
print "drug_chembl_id|drug_claim_name\tinteraction_claim_source\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $interaction_claim_source = $f[1];
       push @{$hash1{$drug_claim_name}},$interaction_claim_source;
   }
}

while(<$I2>)
{
   chomp;
   my @f = split/\t/;
   my $NCDid = $f[0];
   my $phase = $f[2];
   my $drug_claim_name = $f[3];
   my $drug_indication = $f[5];
   my $drug_indication_source = "clinical.trial";
   my $v2 = "$drug_indication\t$phase\t$NCDid\t$drug_indication_source";
   push @{$hash2{$drug_claim_name}},$v2;
}

 foreach my $drug_claim_name(sort keys %hash1){
       if(exists $hash2{$drug_claim_name}){ 
            my @interaction_claim_source = @{$hash1{$drug_claim_name}};
            my @v2 = @{$hash2{$drug_claim_name}};
             foreach my $interaction_claim_source(@interaction_claim_source){
                foreach my $v2(@v2){
                    my $k3 = "$drug_claim_name\t$interaction_claim_source\t$v2";
                    unless(exists $hash3{$k3}){
                        print $O1 "$k3\n";
                        $hash3{$k3} = 1;
                    }   
                }
             }
        }
        else{                                                             #既没有匹配到chembl_id，也没有匹配到drug_claim_name。属于没有indication的药物。
            my @interaction_claim_source = @{$hash1{$drug_claim_name}};
            foreach my $interaction_claim_source(@interaction_claim_source){
                my $k4 = "$drug_claim_name\t$interaction_claim_source";
                    unless(exists $hash4{$k4}){
                        print $O2 "$k4\n";
                        $hash4{$k4} = 1;
                     }
            }
        }
 }

       
       
close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

