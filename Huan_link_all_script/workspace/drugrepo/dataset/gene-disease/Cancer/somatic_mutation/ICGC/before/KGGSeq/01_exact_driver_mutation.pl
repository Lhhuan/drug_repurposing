
#挑出是driver 的mutation
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./kggscore.flt.txt";
my $fo1 = "./simple_somatic_mutation_largethan1_nm_coding_driver.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
select $O1;
# my (%hash1,%hash2);
          
while(<$I1>)
{
    unless (/^Chromosome/){
        chomp;
        my @f= split /\s+/;
        if ($f[40] =~/Y/){
            print  "$_\n";
        }
    }   
}


