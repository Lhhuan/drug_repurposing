#用../cadd_score/SNV_Indel_cadd_score_simple.txt为ID_project_occur_QC.txt添加Pathogenic score ,得merge_occur_QC_pathogenicity_score.txt，没有CADD 的文件./no_cadd_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../cadd_score/SNV_Indel_cadd_score_simple.txt";
my $f2 = "./ID_project_occur_QC.txt";
my $fo1 = "./merge_occur_QC_pathogenicity_score.txt";
my $fo2 = "./no_cadd_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3);
print $O1 "ID\tproject\tcancer_specific_affected_donors\tCADD_PHRED\n";

while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $ID = $f[2];
        my $CADD_PHRED = $f[-1];
        $hash1{$ID}=$CADD_PHRED;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f= split/\t/;
        my $ID = $f[0];
        my $project = $f[1];
        my $cancer_specific_affected_donors = $f[2];
        if (exists $hash1{$ID}){
            my $CADD_PHRED = $hash1{$ID};
            my $output = "$_\t$CADD_PHRED";
            unless(exists $hash3{$output}){
                $hash3{$output}=1;
                print $O1 "$output\n";
            }
        }
        else{
            unless(exists $hash2{$ID}){
                $hash2{$ID} =1;
                print $O2 "$ID\n";
            }
        }
        
    }
}

