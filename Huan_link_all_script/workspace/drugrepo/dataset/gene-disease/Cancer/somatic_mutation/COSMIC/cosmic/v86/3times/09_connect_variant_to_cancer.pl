#将变异(mutation_id)与特定的癌症联系起来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
my $f1 = "./Cosmic_all_ref_alt.txt"; #为CosmicNonCodingVariants_largethan2_nm_vep.vcf 和 CosmicCodingMuts_largethan2_nm_vep.vcf添加ref 和 alt等信息,得文件Cosmic_all_ref_alt.txt
my $f2 = "../../02_mutation_id-id-tumour_nci-code_efo.txt";
my $fo1 = "./09_Cosmic_all_ref_alt_cancer.txt"; #能联系起来的mutation和cancer
my $fo2 = "./09_Cosmic_all_ref_alt_no_cancer.txt"; #不能和cancer联系起来的mutation
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header1 = "mutation_id\tposition\tref\talt";
my $header = "$header1\tID_tumour\tID_sample\tmutation_pos\tNCI_Code\tSite_Primary\tSite_Subtype1\tSite_Subtype2\tSite_Subtype3\tHistology\tHist_Subtype1";
$header = "$header\tHist_Subtype2\tHist_Subtype3\tSite_Primary_COSMIC\tSite_Subtype1_COSMIC\tSite_Subtype2_COSMIC\tSite_Subtype3_COSMIC\tHistology_COSMIC\tHist_Subtype1_COSMIC\tHist_Subtype2_COSMIC\tHist_Subtype3_COSMIC\tEFO";

select $O1;
print "$header\n";
select $O2;
print "$header1\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^position/){
         my $position = $f[0];
         my $ref = $f[1];
         my $alt = $f[2];
         my $mutation_id = $f[3];
         my $v = "$position\t$ref\t$alt";
         $hash1{$mutation_id}=$v;
         #print STDERR "123\n";
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID_tumour/){
         my $mutation_id = $f[1];
         my $t = join "\t", @f[0,2..21];
         push @{$hash2{$mutation_id}},$t;
         #print STDERR "12345\n";

     }
}

foreach my $key (sort keys %hash1){
    if (exists $hash2{$key}){
        my @value = @{$hash2{$key}};
        my $s = $hash1{$key};
        #print STDERR "$s####\n";
        foreach my $v(@value){
            my $k3 = "$key\t$s\t$v";
            #print STDERR "####123####";
            unless(exists $hash3{$k3}){
                 print $O1 "$k3\n";
                 $hash3{$k3} = 1;
           } 
        }  
    }
    else{
        my $s = $hash1{$key};
        print $O2 "$key\t$s\n";
    }
}