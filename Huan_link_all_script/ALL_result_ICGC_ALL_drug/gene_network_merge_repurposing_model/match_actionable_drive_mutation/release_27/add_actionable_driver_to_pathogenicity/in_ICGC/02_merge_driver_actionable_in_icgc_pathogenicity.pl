#将在pathogenicity icgc 中的actionable 和driver mutation merge 到一起。
#将../../actionable_mutation/actionable_hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt 和../../driver_mutation/hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt 
#和 "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_pathogenicity_cgi.txt"merge到一起，得
#./output/01_all_driver_action_in_pathogenicity_ICGC.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../../actionable_mutation/actionable_hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt";
my $f2 = "../../driver_mutation/hit_pathogenic/output/04_actionable_mutaton_in_pathogenicity.txt";
my $f3 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/in_pathogenicity_cgi.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/02_all_driver_action_in_pathogenicity_ICGC.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my %hash1;
my $header = "variant_id\tfinal_variant\thgvsg\tICGC_Mutation_ID\tsource";
print  $O1 "$header\n";
print $O2 "ICGC_Mutation_ID\tsource\n";



while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tactionable_mutation\n";
        my $ICGC_Mutation_ID = $f[3];
        my $source = "actionable_mutation";
        push @{$hash1{$ICGC_Mutation_ID}},$source;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tdriver_mutation\n";
        my $ICGC_Mutation_ID = $f[3];
        my $source = "driver_mutation";
        push @{$hash1{$ICGC_Mutation_ID}},$source;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
        # print $O1 "$_\tcgi_oncogenic_mutation\n";
        my $ICGC_Mutation_ID = $f[0];
        my $hgvsg =$f[1];
        my $source = "cgi_oncogenic_mutation";
        unless($ICGC_Mutation_ID =~/Add/){
            print $O1 "NA\tNA\t$hgvsg\t$ICGC_Mutation_ID\t$source\n";
        }
        push @{$hash1{$ICGC_Mutation_ID}},$source;
    }
}

foreach my $id (sort keys %hash1){
    my @sources = @{$hash1 {$id}};
    my %hash2 ;
    @sources = grep { ++$hash2{$_}<2} @sources;
    my $source =join(";",@sources);
    print $O2 "$id\t$source\n";
}
