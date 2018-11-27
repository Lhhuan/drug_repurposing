#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./step10_drug_unmatch_indication.txt"; 
my $f2  ="./Drugbank_drug_indication.txt";
my $fo1 = "./step12_drug_unmatch_indication_in_drugbank1.txt";
my $fo2 = "./step12_drug_unmatch_indication_in_drugbank2.txt";
my $fo3 = "./step12_drug_unmatch_indication_out_drugbank.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print "drug_name\tinteraction_claim_source\taction_type\tdrug_level\tindication\tchembl_id\n";
select $O2;
print "drug_chembl_id\tinteraction_claim_source\taction_type\tdrug_level\tindication\tdrug_name\n";
select $O3;
print "drug_chembl_id|drug_claim_name\tinteraction_claim_source\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
        my @f = split/\t/;
        my $drug_name = $f[0];
        my $drug_interaction_source = $f[1];
        push @{$hash1{$drug_name}},$drug_interaction_source;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^ENSGID/){
        my @f = split/\t/;
        my $drug_name = $f[3];
        my $action_type = $f[6];
        my $drug_level = $f[8];
        my $indication = $f[9];
        my $chembl_id = $f[16];
        my $v2 = "$action_type\t$drug_level\t$indication\t$chembl_id";
        my $v3 = "$action_type\t$drug_level\t$indication\t$drug_name";
        $hash2{$drug_name} = $v2;
        $hash3{$chembl_id} = $v3;
   }
}

foreach my $drug_name(sort keys %hash1){
       if(exists $hash2{$drug_name}){ #以$drug_name为key进行匹配
            my @interaction_claim_source = @{$hash1{$drug_name}};
            my $v2 = $hash2{$drug_name};
             foreach my $interaction_claim_source(@interaction_claim_source){
                 my $k4 = "$$drug_name\t$interaction_claim_source\t$v2";
                 unless(exists $hash4{$k4}){
                    print $O1 "$k4\n";
                    $hash4{$k4} = 1;
                }   
                
             }
        }
        elsif(exists $hash3{$drug_name}){#以chembl_id为key进行匹配
            my @interaction_claim_source = @{$hash1{$drug_name}};
            my $v3 = $hash3{$drug_name};
            foreach my $interaction_claim_source(@interaction_claim_source){
                my $k5 = "$drug_name\t$interaction_claim_source\t$v3";
                unless(exists $hash5{$k5}){
                    print $O2 "$k5\n";
                    $hash5{$k5} = 1;
                    }    
             }
        }
        else{
            my @interaction_claim_source = @{$hash1{$drug_name}};
            foreach my $interaction_claim_source(@interaction_claim_source){
                my $k6 = "$drug_name\t$interaction_claim_source";
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

