#把文件cosmic_coding_path.txt中的数据所对应的Cosmic_all_ref_alt.txt中的信息提出来。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../01_cosmic_coding_path_info.txt";
#my $fo1 = "./01_gene_vairant_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# my $title = "ENSG_ID\tsymbol\tvariant_type\n";
# select $O1;
#print $title;
my(%hash1,%hash2,%hash3);
print "ENSG_ID\tsymbol\tvariant_type\n";                     
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^position/){
         my $ENSG_ID = $f[3];
         my $variant_type = $f[5];
         my $symbol = $f[6];
         my $header = "$ENSG_ID\t$symbol\t$variant_type";
         
         print "$header\n";
                     
     }
}                    


