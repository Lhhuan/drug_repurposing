#将./pathogenic_hotspot/all_tra_inv_gene.bed的0—based 转换成1-baesd,并且和./pathogenic_hotspot/all_tra_inv.txt merge到一起得./pathogenic_hotspot/03_all_tra_inv_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./pathogenic_hotspot/all_tra_inv_gene.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./pathogenic_hotspot/all_tra_inv.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./pathogenic_hotspot/03_all_tra_inv_gene.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "#CHROM1\tBEGIN1\tEND1\tENSG1\tCHROM2\tBEGIN2\tEND2\tENSG2\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tsource\tID\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $CHROM =$f[0];
    my $BEGIN =$f[1];
    my $tran_BEGIN = $BEGIN +1; #1_baesd将begin+1
    my $END = $f[2];
    my $ENSG = $f[6];
    my $k = "$CHROM\t$tran_BEGIN\t$END";
    push @{$hash1{$k}},$ENSG;
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^#CHROM/){
        my $CHROM1 =$f[0];
        my $BEGIN1 =$f[1];
        my $END1 =$f[2];
        my $CHROM2 = $f[3];
        my $BEGIN2 =$f[4];
        my $END2 =$f[5];
        my $PROJECT =$f[6];
        my $SVSCORETOP10 =$f[7];
        my $SVSCOREMAX =$f[8];
        my $SVSCORESUM =$f[9];
        my $SVSCOREMEAN =$f[10];
        my $source = $f[11];
        my $out = join("\t",@f[6..11]);
        # my $output = "$CHROM1\t$tran_BEGIN1\t$END1\n$CHROM2\t$tran_BEGIN2\t$END2";
        # print $O2 "$output\n";
        my $k1 = "$CHROM1\t$BEGIN1\t$END1";
        my $k2 = "$CHROM2\t$BEGIN2\t$END2";
        print $O1 "$k1\t";
        if (exists $hash1{$k1}){
            my @ensgs1 = @{$hash1{$k1}};
            my %hash2;
            @ensgs1 = grep { ++$hash2{$_} < 2 } @ensgs1;
            my $outk1 = join (",",@ensgs1);
            print $O1 "$outk1\t";
        }
        else{
            print $O1 "NA\t";
        }
        print $O1 "$k2\t";
        if (exists $hash1{$k2}){
            my @ensgs2 = @{$hash1{$k2}};
            my %hash3;
            @ensgs2 = grep { ++$hash3{$_} < 2 } @ensgs2;
            my $outk2 = join (",",@ensgs2);
            print $O1 "$outk2\t";
        }
        else{
             print $O1 "NA\t";
        }
        my $num = $.-1;
        my $ID = "ID_tra_inv$num";
        print $O1 "$out\t$ID\n";
    }
}

