#将./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt和./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt merge在一起，得./pathogenic_hotspot/05_merge_all_cnv_sv_project.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";
my $f2 ="./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt";
my $fo1 ="./pathogenic_hotspot/05_merge_all_cnv_sv_project.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "PROJECT\tsource\tSVTYPE\tID\tSVSCORETOP10";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $PROJECT = $f[8];
        my $SVSCORETOP10 = $f[9];
        my $source = $f[13];
        my $ID = $f[14];
        my $SVTYPE = "NA";
        my $output = "$PROJECT\t$source\t$SVTYPE\t$ID\t$SVSCORETOP10";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $PROJECT = $f[3];
        my $SVSCORETOP10 =$f[4];
        my $SVTYPE = $f[8];
        my $source = $f[9];
        my $ID = $f[10];
        my $output = "$PROJECT\t$source\t$SVTYPE\t$ID\t$SVSCORETOP10";
        unless(exists $hash1{$output}){
            $hash1{$output} =1;
            print $O1 "$output\n";
        }        
    }
}

