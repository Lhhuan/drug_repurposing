#将./CGI/cancer_bioactivities_db.tsv 和./output/all_drug_infos_score.txt merge 到一起，得./output/drug_target_score_and_bioactivities.txt
#得./output/all_drug_infos_score_bioactivities.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CGI/cancer_bioactivities_db.tsv";
my $f2 ="./output/all_drug_infos_score.txt";
my $fo1 ="./output/drug_target_score_and_bioactivities.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_chembl_id_Drug_claim_primary_name\tGene_symbol\tENSG_ID\tdrug_target_score\tPACTIVITY_median\n";
my (%hash1, %hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^SYMBOL/)
    {
        my $SYMBOL = $f[0];
        $SYMBOL =uc($SYMBOL);
        my $PACTIVITY_median = $f[4];
        my $MOLECULE_CHEMBL_ID = $f[5];
        my $k = "$MOLECULE_CHEMBL_ID\t$SYMBOL";
        $hash1{$k}=$PACTIVITY_median;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Gene_symbol = $f[1];
        $Gene_symbol =uc($Gene_symbol);
        my $ENSG_ID =$f[14];
        my $drug_target_score = $f[-1];
        $drug_target_score =~ s/NA/1/g;
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol";
        my $out1 = "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$ENSG_ID\t$drug_target_score";
        unless($Gene_symbol =~/NULL/){
            if (exists $hash1{$k}){
                my $PACTIVITY_median = $hash1{$k};
                my $output ="$out1\t$PACTIVITY_median";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
            else{
                my $output ="$out1\t0";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}