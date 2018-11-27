#对../CosmicCompleteCNA.tsv.gz 进行unique，避免同一个人的同一突变多次出现而误当成occur 变大，得文件CosmicCompleteCNAunique.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
use Compress::Zlib;
my $fo1 = "./CosmicCompleteCNAunique.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "CNV_ID\tID_SAMPLE\tSAMPLE_NAME\tTOTAL_CN\tMINOR_ALLELE\tMUT_TYPE\tChromosome:G_Start..G_Stop\n";
my $file = "../CosmicCompleteCNA.tsv.gz";
my $gz = gzopen($file, "rb")
    or die "Cannot open $file: $gzerrno\n" ;
my %hash1;
while ($gz->gzreadline($_) > 0) {
    chomp;
    my @f = split/\t/;
    unless(/^CNV_ID/){
        my $CNV_ID = $f[0];
        my $ID_SAMPLE = $f[3];
        my $SAMPLE_NAME = $f[13];
        my $TOTAL_CN = $f[14];
        my $MINOR_ALLELE = $f[15];
        my $MUT_TYPE = $f[16];
        my $Chromosome_G_Start_G_Stop = $f[19];
        my $k = "$CNV_ID\t$ID_SAMPLE\t$SAMPLE_NAME\t$TOTAL_CN\t$MINOR_ALLELE\t$MUT_TYPE\t$Chromosome_G_Start_G_Stop";
        unless(exists $hash1{$k}){
            $hash1{$k}=1;
            print $O1 "$k\n";
        }
    }
}

die "Error reading from $file: $gzerrno\n" if $gzerrno != Z_STREAM_END ;
$gz->gzclose() ;
