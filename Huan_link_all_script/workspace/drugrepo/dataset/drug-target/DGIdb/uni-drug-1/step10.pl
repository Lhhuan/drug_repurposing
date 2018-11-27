#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step9_drug_unmatch_indication.txt";
my $f2 = "./drugcentral_drug_indication.txt";
my $fo1 = "./step10_drug_indication1.txt";
my $fo2 = "./step10_drug_indication2.txt";
my $fo3 = "./step10_drug_unmatch_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print"drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\tdrug_substance_name\tdisease_concept_name\tdisease_full_name\tdrug_indication_source\n";
select $O2;
print"drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\tdrug_substance_name\tdisease_concept_name\tdisease_full_name\tdrug_indication_source\n";
select $O3;
print "drug_chembl_id|drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $drug_stage = $f[1];
       my $interaction_type = $f[2];
       my $interaction_claim_source = $f[3];
       my $t = "$drug_stage\t$interaction_type\t$interaction_claim_source";
       push @{$hash1{$drug_claim_name}},$t;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^struct/){
       my @f = split/\t/;
       my $drug_active_name = $f[1];
       my $drug_substance_name = $f[2];
       my $disease_concept_name = $f[3];
       my $disease_full_name = $f[4];
       my $drug_indication_source = "drugcentral";
       my $v2 = "$drug_substance_name\t$disease_concept_name\t$disease_full_name\t$drug_indication_source";
       my $v3 = "$drug_active_name\t$disease_concept_name\t$disease_full_name\t$drug_indication_source";
       push @{$hash2{$drug_active_name}},$v2;
       push @{$hash3{$drug_substance_name}},$v3;
   }
}

 foreach my $drug_claim_name(sort keys %hash1){
       if(exists $hash2{$drug_claim_name}){ #以$drug_active_name为key进行匹配
            my @t = @{$hash1{$drug_claim_name}};
            my @v2 = @{$hash2{$drug_claim_name}};
             foreach my $t(@t){
                foreach my $v2(@v2){
                    my $k4 = "$drug_claim_name\t$t\t$v2";
                    unless(exists $hash4{$k4}){
                        print $O1 "$k4\n";
                        $hash4{$k4} = 1;
                    }   
                }
             }
        }
        elsif(exists $hash3{$drug_claim_name}){ ##以$drug_active_name为key 进行检索不存在的数据，用$drug_substance_name为key进行匹配
            my @t = @{$hash1{$drug_claim_name}};
            my @v3 = @{$hash3{$drug_claim_name}};
             foreach my $t(@t){
                foreach my $v3(@v3){
                    my $k5 = "$drug_claim_name\t$t\t$v3";
                    unless(exists $hash5{$k5}){
                        print $O2 "$k5\n";
                        $hash5{$k5} = 1;
                    }   
                }
             }
        }
        else{                                                             #既没有匹配到$drug_active_name，也没有匹配到$drug_substance_name。属于没有indication的药物。
            my @t = @{$hash1{$drug_claim_name}};
            foreach my $t(@t){
                my $k6 = "$drug_claim_name\t$t";
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

