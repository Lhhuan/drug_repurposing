#将../output/10_prediction_logistic_regression.txt 和../output/021_merge_sample_oncotree_chembl.txt merge 到一起，得../output/11_merge_prediction_repurposing_drug_sensitive_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../output/021_merge_sample_oncotree_chembl.txt";
my $f2 = "../output/10_prediction_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/11_merge_prediction_repurposing_drug_sensitive_info.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^CCLE_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[-1]; 
        my $CCLE_name = $f[0];
        my $Compound = $f[5];
        my $AUC = $f[10];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$CCLE_name";
        my $v = "$Compound\t$AUC";
        push @{$hash1{$k}},$v;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug/){
        print $O1 "$_\tCompound\tAUC\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $CCLE_name = $f[3];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$CCLE_name";
        if (exists $hash1{$k}){
            my @vs = @{$hash1{$k}};
            foreach my $v(@vs){
                my $output = "$_\t$v";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
        else{
            print STDERR "$k\n";
        }
    }
}
