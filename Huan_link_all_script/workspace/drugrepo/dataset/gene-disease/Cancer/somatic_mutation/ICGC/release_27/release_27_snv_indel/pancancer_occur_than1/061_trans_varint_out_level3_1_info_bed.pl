#把06_varint_out_level3_1_info.vcf转为bed 格式，即给06_varint_out_level3_1_info.vcf文件加一列，得06_varint_out_level3_1_info.bed
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./06_varint_out_level3_1_info.vcf";
my $fo1 = "./06_varint_out_level3_1_info.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    if (/^#/){
        #print $O1 "$_\n";
        print STDERR  "$_\n";
    }
     else{
         my @f =split/\s+/;
         my $CHROM = $f[0];
         my $POS =$f[1];
         my $variation_id = $f[2];
         my $REF = $f[3];
         my $ALT = $f[4];
         my $QUAL = $f[5];
         my $FILTER = $f[6];
         my $INFO = $f[7];
         my $start = $POS -1;
         my $out = "$CHROM\t$start\t$POS\t$variation_id\t$REF\t$ALT";
         print $O1 "$out\n";
     }
}




