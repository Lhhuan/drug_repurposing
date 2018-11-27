
# 为simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt 的coding variant score进行打分。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt";
my $f2 ="./revel_all_chromosomes.csv";
my $fo1 = "./simple_somatic_mutation_largethan1_nm_vep_coding_revel.txt";
my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding_no_revel.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print "chr:pos.alt.ref\taaref\taaalt\trevel_score\tdisease\tID\tENSG_ID\tvariant_type\tsymbol\n";
select $O2;
print "chr:pos.alt.ref\tdisease\tID\tENSG_ID\tvariant_type\tsymbol\n";
my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^position/){
         my $position = $f[0];
         my $ref = $f[1];
         my $alt = $f[2];
         my $key1 = "$position.$ref.$alt";
         my $disease = $f[3];
         my $ID = $f[4];
         my $ENSG_ID = $f[6];
         my $variant_type = $f[7];
         my $symbol = $f[8];
         my $t = join "\t", @f[3,4,6..8];
         push @{$hash1{$key1}},$t;

     }
}
          
while(<$I2>)
{
    chomp;
    my @f= split /\,/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $position = "$chr:$pos";
    my $ref = $f[2];
    my $alt = $f[3];
    my $aaref = $f[4];
    my $aaalt = $f[5];
    my $revel_score = $f[6];
    my $key2 = "$position.$ref.$alt";
    my $s = join "\t", @f[4..6];
    $hash2{$key2}=$s;
}

foreach my $key (sort keys %hash1){
    if (exists $hash2{$key}){
        my @value = @{$hash1{$key}};
        my $s = $hash2{$key};
        foreach my $t(@value){
            print $O1 "$key\t$s\t$t\n";
        }    
    }
    else{
        my @value = @{$hash1{$key}};
         foreach my $t(@value){
             print $O2 "$key\t$t\n";
         }
    }
}