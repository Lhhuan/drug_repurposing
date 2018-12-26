#因为现在是gene只要落在INV和tra的一个break point 就认为这个基因落在Hotspot。
#所以将./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt和./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt merge在一起，得./pathogenic_hotspot/05_all_sv_cnv_oncotree.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";
my $f2 ="./pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt";
my $fo1 ="./pathogenic_hotspot/05_all_sv_cnv_oncotree.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue";
# my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG\toncotree_ID_main_tissue";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $CHROM1 = $f[0];
        my $BEGIN1 = $f[1];
        my $END1 = $f[2];
        my $ENSG1 = $f[3];
        my $CHROM2 = $f[4];
        my $BEGIN2 = $f[5];
        my $END2 = $f[6];
        my $ENSG2 = $f[7];
        my $PROJECT = $f[8];
        my $SVSCORETOP10 = $f[9];
        my $SVSCOREMAX = $f[10];
        my $SVSCORESUM = $f[11];
        my $SVSCOREMEAN = $f[12];
        my $source = $f[13];
        my $ID = $f[14];
        my $oncotree_term_detail = $f[15];
        my $oncotree_ID_detail =$f[16];
        my $oncotree_term_main_tissue =$f[17];
        my $oncotree_ID_main_tissue = $f[18];
        my $SVTYPE = "NA";
        my $k1 = "$CHROM1\t$BEGIN1\t$END1\t$PROJECT\t$SVSCORETOP10\t$SVSCOREMAX\t$SVSCORESUM\t$SVSCOREMEAN\t$SVTYPE\t$source\t$ID\t$ENSG1\t$oncotree_term_detail\t$oncotree_ID_detail\t$oncotree_term_main_tissue\t$oncotree_ID_main_tissue";
        my $k2 = "$CHROM2\t$BEGIN2\t$END2\t$PROJECT\t$SVSCORETOP10\t$SVSCOREMAX\t$SVSCORESUM\t$SVSCOREMEAN\t$SVTYPE\t$source\t$ID\t$ENSG2\t$oncotree_term_detail\t$oncotree_ID_detail\t$oncotree_term_main_tissue\t$oncotree_ID_main_tissue";
        unless(exists $hash1{$k1}){
            $hash1{$k1}=1;
            print $O1 "$k1\n";
        }
        unless(exists $hash1{$k2}){
            $hash1{$k2}=1;
            print $O1 "$k2\n";
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $k = $_;
        unless(exists $hash1{$k}){
            $hash1{$k}=1;
            print $O1 "$k\n";
        }
    }
}

