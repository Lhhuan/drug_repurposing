#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step1-interactions_v3-uni-drug_database.txt";
my $f2 = "./step4_all_drug_indication.txt";
my $fo1 = "./step5_all_drug_indication1.txt";
my $fo2 = "./step5_all_drug_indication2.txt";
my $fo3 = "./step5_all_drug_unmatch_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print"drug_chembl_id\tinteraction_claim_source\tdrug_claim_name\tdrug_indication\tdrug_indication_source\n";
select $O2;
print"drug_claim_name\tinteraction_claim_source\tdrug_chembl_id\tdrug_indication\tdrug_indication_source\n";
select $O3;
print "drug_chembl_id|drug_claim_name\tinteraction_claim_source\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $interaction_claim_source = $f[1];
       push @{$hash1{$drug_chembl_id}},$interaction_claim_source;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_name = $f[1];
       my $drug_indication = $f[2];
       my $drug_indication_source = $f[3];
       my $v2 = "$drug_claim_name\t$drug_indication\t$drug_indication_source";
       my $v3 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source";
       push @{$hash2{$drug_chembl_id}},$v2;
       push @{$hash3{$drug_claim_name}},$v3;
   }
}

 foreach my $drug_chembl_id(sort keys %hash1){
       if(exists $hash2{$drug_chembl_id}){ 
            my @interaction_claim_source = @{$hash1{$drug_chembl_id}};
            my @v2 = @{$hash2{$drug_chembl_id}};
             foreach my $interaction_claim_source(@interaction_claim_source){
                foreach my $v2(@v2){
                    my $k4 = "$drug_chembl_id\t$interaction_claim_source\t$v2";
                    unless(exists $hash4{$k4}){
                        print $O1 "$k4\n";
                        $hash4{$k4} = 1;
                    }   
                }
             }
        }
        elsif(exists $hash3{$drug_chembl_id}){ #没有chembl_id的用drug_claim_name匹配。
             my @interaction_claim_source = @{$hash1{$drug_chembl_id}};
             my @v3 = @{$hash3{$drug_chembl_id}};
             foreach my $interaction_claim_source(@interaction_claim_source){
                foreach my $v3(@v3){
                    my $k5 = "$drug_chembl_id\t$interaction_claim_source\t$v3";
                    unless(exists $hash5{$k5}){
                        print $O2 "$k5\n";
                        $hash5{$k5} = 1;
                    }
                }
             }

        }
        else{                                                             #既没有匹配到chembl_id，也没有匹配到drug_claim_name。属于没有indication的药物。
            my @interaction_claim_source = @{$hash1{$drug_chembl_id}};
            foreach my $interaction_claim_source(@interaction_claim_source){
                my $k6 = "$drug_chembl_id\t$interaction_claim_source";
                    unless(exists $hash6{$k6}){
                        print $O3 "$k6\n";
                        $hash6{$k6} = 1;
                     }
            }
        }
 }

       
       
close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";

