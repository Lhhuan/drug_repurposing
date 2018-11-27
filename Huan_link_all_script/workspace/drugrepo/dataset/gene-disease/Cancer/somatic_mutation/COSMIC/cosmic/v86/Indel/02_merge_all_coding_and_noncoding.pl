
#将所有的largethan1_nm的数据合在一起，为后来分类后的coding和noncoding寻找ref和alt做铺垫。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CosmicNonCodingVariants_largethan2_nm_indel.vcf";
my $f2 ="./CosmicCodingMuts_largethan2_nm_indel.vcf";
my $fo1 = "./All_cosmic_Muts_largethan2_nm_indel.vcf";
# my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
# #my $title = "CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n";
select $O1;
# print $title;
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    if (/^#/){
        print "$_\n";

    }
    else{
         print "$_\n";

     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^#/){
         print "$_\n";

     }
}
