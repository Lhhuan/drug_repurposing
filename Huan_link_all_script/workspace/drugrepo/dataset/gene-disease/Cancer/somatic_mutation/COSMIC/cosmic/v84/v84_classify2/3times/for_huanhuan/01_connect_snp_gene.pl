
#将文件ds_res.csv在上一级目录Cosmic_all_ref_alt.txt中找vep注释信息。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./ds_res.csv";
my $f2 ="../Cosmic_all_ref_alt.txt";
my $fo1 = "./01_noncoding_path_vep.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
my $title = "chr\tpos\tref\talt\tENSG_ID\tsymbol\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $ref = $f[2];
    my $alt = $f[3];
    my $k = "$chr:$pos.$ref.$alt";
    $hash1{$k} = 1;              
}
                
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    my $position = $f[0];
    my $ref = $f[1];
    my $alt = $f[2];
    my $ENSG_ID = $f[5];
    my $symbol = $f[8];
    my $k = "$position.$ref.$alt";
    my $v = "$ENSG_ID\t$symbol";
    push @{$hash2{$k}},$v;
}

foreach my $k (sort keys %hash1){
    if (exists $hash2{$k}){
        my @value = @{$hash2{$k}};
        my @f= split /\:/,$k;
        my $chr = $f[0];
        my @p = split/\./,$f[1];
        my $pos = $p[0];
        my $ref = $p[1];
        my $alt = $p[2];
        foreach my $t(@value){
            my $output = "$chr\t$pos\t$ref\t$alt\t$t";
            unless(exists $hash3{$output}){
                print $O1 "$output\n";
                $hash3{$output} = 1;
            }
        }    
    }
}
