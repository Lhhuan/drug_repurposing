#将"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/out_ICGC/output/03_merge_cgi_and_other_mutation_out_icgc.txt"
#中的symbol 分开，增加，mutation_id,得10_split_add_hgvsg_symbol.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/out_ICGC/output/03_merge_cgi_and_other_mutation_out_icgc.txt";
my $fo1 = "./10_split_add_hgvsg_symbol.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";



while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if(/^final_variant/){
        print $O1 "$_\tGene\tvariant_id\n";
    }
    else{
        my $final_variant = $f[0];
        my $hgvsg = $f[1];
        my $disease= $f[2];
        my $cancer_id = $f[3];
        my $project = $f[4];
        my $variant_id = "Add"."$hgvsg";
        my @ts = split/\:/,$final_variant;
        my $gene = $ts[0];
        my $output = "$_\t$gene\t$variant_id";
        print $O1 "$output\n";
    }
}


