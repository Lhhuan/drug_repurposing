
#vep注释出来coding添加原来vcf中的alt,ref等信息。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CosmicCodingMuts_largethan1_nm_vep.vcf";
my $f2 ="./CosmicNonCodingVariants_largethan1_nm_vep.vcf";
my $f3 ="./All_cosmic_Muts_largethan1_nm.vcf";
my $fo1 = "./Cosmic_all_ref_alt.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "ID\tAlt_allele\tlocation\tENSG_ID\tvariant_type\tsymbol\tposition\tref\talt\tdisease\n";
my $title = "position\tref\talt\tID\tlocation\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^#/){
         unless($f[2] =~ /-/){  #不要insertion的
             unless($f[1] =~ /-/){  #不要deletion的
                 my $ID = $f[0];
                 my $location = $f[1];
                 my $alt_allele = $f[2];
                 my $ENSG_ID = $f[3];
                 my $variant_type = $f[6];
                 my $extra = $f[13];
                 my @fs = split /;/,$extra;
                 my @fv = split/\,/,$variant_type;
                 foreach my $variant(@fv){
                     if ($ENSG_ID =~ /-/){
                         my $symbol = "NA";
                         my $header = "$location\t$ENSG_ID\t$variant\t$symbol";
                         push @{$hash1{$ID}},$header;
                     }
                    else{
                        foreach my $i(@fs){
                            if ($i=~/SYMBOL=/){
                                my @fg = split /=/,$i;
                                my $symbol = $fg[1];
                                my $header = "$location\t$ENSG_ID\t$variant\t$symbol";
                                push @{$hash1{$ID}},$header;
                            }
                        } 
                    }
                 }
            }
         }
     }
}
                
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^#/){
         unless($f[2] =~ /-/){  #不要insertion的
             unless($f[1] =~ /-/){  #不要deletion的
                 my $ID = $f[0];
                 my $location = $f[1];
                 my $alt_allele = $f[2];
                 my $ENSG_ID = $f[3];
                 my $variant_type = $f[6];
                 my $extra = $f[13];
                 my @fs = split /;/,$extra;
                 my @fv = split/\,/,$variant_type;
                 foreach my $variant(@fv){
                     if ($ENSG_ID =~ /-/){
                         my $symbol = "NA";
                         my $header = "$location\t$ENSG_ID\t$variant\t$symbol";
                         push @{$hash2{$ID}},$header;
                     }
                    else{
                        foreach my $i(@fs){
                            if ($i=~/SYMBOL=/){
                                my @fg = split /=/,$i;
                                my $symbol = $fg[1];
                                my $header = "$location\t$ENSG_ID\t$variant\t$symbol";
                                push @{$hash2{$ID}},$header;
                            }
                        } 
                    }
                 }
            }
         }
     }
}                    


while(<$I3>)
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
        $hash3{$id}=$s;
    }
}

foreach my $ID (sort keys %hash3){
    if (exists $hash1{$ID}){
        my @value = @{$hash1{$ID}};
        my $s = $hash3{$ID};
        foreach my $t(@value){
            #print "$ID\t$s\t$t\n";
            print "$s\t$ID\t$t\n";
        }    
    }
}

foreach my $ID (sort keys %hash3){
    if (exists $hash2{$ID}){
        my @value = @{$hash2{$ID}};
        my $s = $hash3{$ID};
        foreach my $t(@value){
            #print "$ID\t$s\t$t\n";
            print "$s\t$ID\t$t\n";
        }    
    }
}