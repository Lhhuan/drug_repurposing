
#vep注释出来coding添加原来vcf中的alt,ref等信息。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./Cosmic_all_coding.txt";
my $f2 ="./All_cosmic_Muts_largethan1_nm.vcf";
my $fo1 = "./Cosmic_all_coding_ref_alt.txt";
# my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
my $title = "position\tref\talt\tID\tlocation\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title;
 my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $ID = $f[0];
         my $Alt_allele = $f[1];
         my $location = $f[2];
         my $ENSG_ID = $f[3];
         my $variant_type = $f[4];
         my $symbol = $f[5];
         my $t = join "\t", @f[2..5];
         push @{$hash1{$ID}},$t;

     }
}
          
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    unless(/^CHROM/){
        my $chr = $f[0];
        my $pos = $f[1];
        my $id = $f[2];
        my $position = "$chr:$pos";
        my $ref = $f[3];
        my $alt = $f[4];
        my $s = join ("\t",$position,$ref,$alt);
        $hash2{$id}=$s;
    }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my @value = @{$hash1{$ID}};
        my $s = $hash2{$ID};
        foreach my $t(@value){
            #print "$ID\t$s\t$t\n";
            print "$s\t$ID\t$t\n";
        }    
    }
}