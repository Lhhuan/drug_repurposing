#用./pathogenic_hotspot/all_CNV_dup_del.bed 结合./pathogenic_hotspot/all_CNV_dup_del_gene.bed 为./pathogenic_hotspot/all_CNV_dup_del.bed的sv 找到gene，
#得./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt 

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./pathogenic_hotspot/all_CNV_dup_del_gene.bed";
my $f2 ="./pathogenic_hotspot/all_CNV_dup_del.bed";
my $fo1 ="./pathogenic_hotspot/03_all_CNV_dup_del_gene.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\tENSG";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $CHROM =$f[0];
        my $tran_BEGIN =$f[1];
        my $BEGIN = $tran_BEGIN +1; #0_baesd转换成1 based 将begin+1
        my $END =$f[2];
        my $PROJECT =$f[3];
        my $SVSCORETOP10 =$f[4];
        my $SVSCOREMAX =$f[5];
        my $SVSCORESUM =$f[6];
        my $SVSCOREMEAN =$f[7];
        my $SVTYPE =$f[8];
        my $source = $f[9];
        my $id =$f[10];   
        my $ensg = $f[14];
        my $k = join("\t",$CHROM,$BEGIN,@f[2..10]);
        push @{$hash1{$k}},$ensg;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $CHROM =$f[0];
        my $tran_BEGIN =$f[1];
        my $BEGIN = $tran_BEGIN +1; #0_baesd转换成1 based 将begin+1
        my $END =$f[2];
        my $PROJECT =$f[3];
        my $SVSCORETOP10 =$f[4];
        my $SVSCOREMAX =$f[5];
        my $SVSCORESUM =$f[6];
        my $SVSCOREMEAN =$f[7];
        my $SVTYPE =$f[8];
        my $source = $f[9];
        my $id =$f[10];   
        my $ensg = $f[14];
        my $k = join("\t",$CHROM,$BEGIN,@f[2..10]);
        if (exists $hash1{$k}){
            my @ensgs = @{$hash1{$k}};
            my %hash2;
            @ensgs = grep { ++$hash2{$_} < 2 } @ensgs;
            my $ensg = join (",",@ensgs);
            print $O1 "$k\t$ensg\n";
        }
        else{
            print $O1 "$k\tNA\n";
        }
    }
}







# while(<$I2>)
# {
#     chomp;
#     my @f= split /\t/;
#     unless(/^#CHROM/){
#         my $CHROM =$f[0];
#         my $tran_BEGIN =$f[1];
#         my $BEGIN = $tran_BEGIN +1; #0_baesd转换成1 based 将begin+1
#         my $END =$f[2];
#         my $k = "$CHROM\t$BEGIN\t$END";
#         unless(exists $hash2{$k}){
#             print $O1 "$_\tNA\n";
#         }
#     }
# }





