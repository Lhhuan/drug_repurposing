#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1  ="./step10_drug_unmatch_indication.txt"; 
my $fo1 = "./step12_drug_unmatch_indication_in_drugbank-expri.txt";
my $fo2 = "./step12_drug_unmatch_indication_in_drugbank-un-expri.txt";
my $fo3 = "./step12_drug_unmatch_indication_out_drugbank.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print "drug_chembl_id|drug_claim_name\tdrug_stage\tinteractio_type\tdrug_interaction_source\n";
select $O2;
print "drug_chembl_id|drug_claim_name\tdrug_stage\tinteractio_type\tdrug_interaction_source\n";
select $O3;
print "drug_chembl_id|drug_claim_name\tdrug_stage\tinteractio_type\tdrug_interaction_source\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
        my @f = split/\t/;
        my $drug_name = $f[0];
        my $drug_stage = $f[1];
        my $interaction_type = $f[2];
        my $drug_interaction_source = $f[3];
        my $key = "$drug_name\t$drug_stage\t$interaction_type\t$drug_interaction_source";
        if ($drug_interaction_source =~ /Drugbank/ ){
            if($drug_stage =~ /Experimental/){
                 unless(exists $hash1{$key}){
                    print $O1 "$key\n";
                    $hash4{$key} = 1;
            }
            else{
                 unless(exists $hash2{$key}){
                    print $O2 "$key\n";
                    $hash2{$key} = 1;
                 }
            }
        }
      }
      else{
          unless(exists $hash3{$key}){
              print $O3 "$key\n";
              $hash3{$key} = 1;
          }
      }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";

