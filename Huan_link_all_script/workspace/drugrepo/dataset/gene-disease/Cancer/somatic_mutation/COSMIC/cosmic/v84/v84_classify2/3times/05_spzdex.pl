
# 为cosmic_all_no_revel_score.txt进行spzdex score进行打分。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./cosmic_all_no_revel_score.txt";
my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/SPZDEX/hg19_spidex.txt";
my $fo1 = "./cosmic_spzdex_score.txt";
my $fo2 = "./cosmic_no_spzdex_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "chr:pos.ref.alt\tdpsi_max_tissue\tdpsi_zscore\tID\tENSG_ID\tvariant_type\tsymbol\n";
print $O2 "chr:pos.ref.alt\tID\tENSG_ID\tvariant_type\tsymbol\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^chr/){
         my $chr_pos_ref_alt = $f[0];
         my $ID = $f[1];
         my $ENSG_ID = $f[2];
         my $variant_type = $f[3];
         my $symbol = $f[4];
         my $t = join "\t", @f[1..4];
         push @{$hash1{$chr_pos_ref_alt}},$t;

     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^#Chr/){
         my $chr = $f[0];
         my $pos = $f[1];
         my $ref = $f[3];
         my $alt = $f[4];
         my $key2 = "$chr:$pos.$ref.$alt";
         my $dpsi_max_tissue = $f[5];
         my $dpsi_zscore = $f[6];
         my $s = join "\t", @f[5,6];
       $hash2{$key2}= $s;

     }
}

foreach my $key (sort keys %hash1){
    if (exists $hash2{$key}){
        my @value = @{$hash1{$key}};
        my $s = $hash2{$key};
        foreach my $t(@value){
            my $k3 = "$key\t$s\t$t";
            #print "$k3\n";
            unless(exists $hash3{$k3}){
                print $O1 "$k3\n";
                $hash3{$k3} = 1;
            }      
        }    
    }
    else{
        my @value = @{$hash1{$key}};
         foreach my $t(@value){
             my $k4 = "$key\t$t";
             unless(exists $hash4{$k4}){
                 print $O2 "$k4\n";
                 $hash4{$k4} = 1;
                }   
         }
    }
}