#把./output/02_mutation_disease_cancer_project.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/03_mutation_disease_cancer_project.txt" merge 到一起，
#得./output/03_merge_cgi_and_other_mutation_out_icgc.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/02_mutation_disease_cancer_project.txt";
my $f2 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/03_mutation_disease_cancer_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/03_merge_cgi_and_other_mutation_out_icgc.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "final_variant\thgvsg\tdisease\tcancer_id\tproject";
print $O1 "$header\n";


while(<$I1>)
{
    chomp;
    unless(/^final_variant/){
        print $O1 "$_\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^gdna/){
        my $hgvs = $f[0];
        my $CHROM= $f[1];
        my $POS= $f[2];
        my $REF = $f[3];
        my $ALT= $f[4];
        my $gene =$f[5];
        my $protein= $f[6];
        my $cancer_acronym = $f[7];
        my $cancer_id = $f[8];
        my $project =$f[9];
        my $final_variant = "$gene:$protein";
        my $output= "$final_variant\t$hgvs\t$cancer_acronym\t$cancer_id\t$project";
        print $O1 "$output\n";
    }
}



