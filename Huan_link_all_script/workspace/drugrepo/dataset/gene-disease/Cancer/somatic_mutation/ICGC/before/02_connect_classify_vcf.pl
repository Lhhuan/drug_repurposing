
#vep注释出来coding添加原来vcf中的alt,ref,以及disease
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./simple_somatic_mutation.largethan1.nm.vcf";
my $f2 ="./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
my $fo1 = "./simple_somatic_mutation_largethan1_nm_vep_coding_disease.txt";
# my $fo2 = "./simple_somatic_mutation_largethan1_nm_vep_coding.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
my $title = "position\tref\talt\tdisease\tID\tlocation\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title;
 my (%hash1,%hash2);
while(<$I2>)
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
          
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $id = $f[2];
    my $position = "$chr:$pos";
    my $ref = $f[3];
    my $alt = $f[4];
    my @info_array = split/;/,$f[7];
    foreach my$i(@info_array){
        if ($i =~/OCCURRENCE/){
            my @occur = split /\|/,$i;
            my @disorder = split /=/,$occur[0];
            my $disease = $disorder[1];
            #my $s = join ("\t",$position,$ref,$alt,$disease);
            my $s = join ("\t",$position,$ref,$alt,$disease);
            $hash2{$id}=$s;
        }
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