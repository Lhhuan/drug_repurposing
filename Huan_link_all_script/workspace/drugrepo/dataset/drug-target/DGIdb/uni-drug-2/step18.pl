#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./step17_drug_no_indication.txt";
my $fi_indication = "./clinical.trial-drug-indication.txt";
my $fo1 = "./step18_drug-indication-exist.txt"; #在clinical.trial中存在适应症的药物
my $fo2 = "./step18_drug_no_indication.txt"; #在clinical.trial中不存在适应症的药物

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $I2, '<', $fi_indication or die "$0 : failed to open input file '$fi_indication' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\tdrug_claim_primary_name\tclinical_drug-name\tdrug_indication\tphase\tNCDid\ttitle\tdrug_indication_source\n";
select $O2;
print"drug_chembl_id\tdrug_stage\tinteraction_type\tinteraction_claim_source\tmax_phase\tfirst_approval\tindication_class\tdrug_claim_primary_name\n";
#open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my($drug_chembl_id, $drug_stage, $interaction_type, $interaction_claim_source, $max_phase, $first_approval, $indication_class, $drug_claim_primary_name) = ($f[0], $f[1], $f[2], $f[3], $f[4], $f[5], $f[6],$f[7]);
       my $key1 = join"\t",@f[0..6]; 
       $hash1{$drug_claim_primary_name} = $key1;
       
   }
}


while(<$I2>)
{
   chomp;
   my @f = split/\t/;
   my $NCDid = $f[0];
   my $title = $f[1];
   my $phase = $f[2];
   my $drug_claim_name = $f[3];
   my $drug_indication = $f[5];
   my $drug_indication_source = "clinical.trial";
   my $v2 = "$drug_indication\t$phase\t$NCDid\t$title\t$drug_indication_source";
   push @{$hash2{$drug_claim_name}},$v2;
}

 foreach my $drug_claim_primary_name(sort keys %hash1){
     my @key2 = keys %hash2;
     foreach my $key2(@key2){
        #  $drug_claim_primary_name =~ s/\+/\\+/g;
        #  $drug_claim_primary_name =~ s/-//g;
        #  $key2 =~s/-//g;
         if($key2 =~ /\b$drug_claim_primary_name\b/i){
        #if($drug_claim_primary_name =~ /\b*$key2*\b/i){
             my $v1 = $hash1{$drug_claim_primary_name};
             my @v = @{$hash2{$key2}};
             foreach my $v2(@v){
                 my $k3= "$v1\t$drug_claim_primary_name\t$key2\t$v2";
                 unless(exists$hash3{$k3}){
                        print $O1 "$k3\n";
                        $hash3{$k3} = 1;
                }
            }
         }
         
        #  else{
        #      print "$drug_claim_primary_name\n##$$_\n";
        #     my $v1 = $hash1{$drug_claim_primary_name};
        #     my $k4 = "$v1\t$drug_claim_primary_name";
        #     unless(exists$hash4{$k4}){
        #         print $O2 "$k4\n";
        #         $hash4{$k4} = 1;
        #     }
        # }
  
     
     }
     
 }




