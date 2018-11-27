
#将文件ds_res.csv在上一级目录Cosmic_all_ref_alt.txt中找vep注释信息。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./01_noncoding_path_vep.txt";
my $fo1 = "./02_noncoding_path_gene.txt";
my $fo2 = "./02_noncoding_path_no_gene.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
my $title = "chr\tpos\tref\talt\tENSG_ID\tsymbol\n";
select $O1;
print $title;
select $O2;
print "chr\tstart\tend\tref\talt\n";

my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    unless(/^chr/){
        my $chr = $f[0];
        my $pos = $f[1];
        my $ref = $f[2];
        my $alt = $f[3];
        my $ENSG_ID = $f[4];
        my $symbol = $f[5];
        if ($symbol=~/NA/){
            print $O1 "$_\n";
        }
        else{
            my $start = $pos -1;
            print $O2 "chr$chr\t$start\t$pos\t$ref\t$alt\n";

        }
    }
            
}
                
