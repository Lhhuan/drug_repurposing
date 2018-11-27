
#用vep注释出来coding中的id,提取原来vcf文件的行。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../simple_somatic_mutation.largethan1.nm.vcf";
my $f2 ="../../simple_somatic_mutation_largethan1_nm_vep_coding.txt";
my $fo1 = "./simple_somatic_mutation_largethan1_nm_coding.vcf";
# my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
select $O1;
 my (%hash1,%hash2);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $ID = $f[0];
         
         $hash1{$ID}=1;

     }
}
          
while(<$I1>)
{
    unless (/^#/){
        chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $id = $f[2];
    $hash2{$id} = $_;
    }   
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
            #print "$s\t$ID\t$t\n";
            print "$s\n";  
    }
}