#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step7_drug_unmatch_indication.txt";
my $f2 = "./chembl_assay.txt";
my $fo1 = "./step9_drug_indication.txt";
my $fo2 = "./step9_drug_unmatch_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print"drug_claim_id\tinteraction_claim_source\tassay_description\tassay_organism\tdrug_indication_source\n";
select $O2;
print "drug_chembl_id|drug_claim_name\tinteraction_claim_source\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0]; #这里的drug_claim_name是drug_chembl_id
       my $interaction_claim_source = $f[1];
       push @{$hash1{$drug_claim_name}},$interaction_claim_source;
   }
}

while(<$I2>)
{
   chomp;
   if(/^\d+/){
       my @f = split/\t/;
       for (my $i=0;$i<19;$i++){
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       my $assay_description = $f[2];
       my $assay_organism = $f[6];
       my $chembl_id = $f[18];
       my $drug_indication_source = "chembl";
       my $v2 = "$assay_description\t$assay_organism\t$drug_indication_source";
       push @{$hash2{$chembl_id}},$v2;

   }
   
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
        else{                                                             #既没有匹配到chembl_id，属于没有indication的药物。
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

