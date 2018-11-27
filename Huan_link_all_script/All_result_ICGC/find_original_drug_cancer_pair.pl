#把21_all_drug_infos.txt中原本治疗cancer 的drug筛选出来，得original_drug_cancer_pair.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./21_all_drug_infos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./original_drug_cancer_pair.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Drug_chembl_id_Drug_claim_primary_name\tindication_OncoTree_main_ID" ;


my %hash1;
while(<$I1>)
{
    chomp;
    unless(/^Drug_chembl_id|Drug_claim_primary_name/){
        my @f= split /\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $indication_OncoTree_main_IDs = $f[-1];
        $indication_OncoTree_main_IDs =~ s/"//g;
        unless($indication_OncoTree_main_IDs=~/NA/){
            my @f2 = split/\;/,$indication_OncoTree_main_IDs; #因为一个drug可能多个Indication
            foreach my $indication_OncoTree_main_ID(@f2){ 
                unless($indication_OncoTree_main_ID=~/NA/){
                    my $output= "$Drug_chembl_id_Drug_claim_primary_name\t$indication_OncoTree_main_ID";
                    unless(exists $hash1{$output}){
                        $hash1{$output} =1;
                        print $O1 "$output\n";
                    }
                }
            }
        }
    }
}


