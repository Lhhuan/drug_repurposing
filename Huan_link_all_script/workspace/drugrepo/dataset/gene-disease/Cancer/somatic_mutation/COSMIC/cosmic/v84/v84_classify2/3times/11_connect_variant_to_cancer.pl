#将变异(mutation_id)与特定的癌症联系起来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
my $f1 = "./10_all_occur_more_than2_mutation_id_info.txt"; #所有出现次数大于2的编码和非编码的mutaion_id 和其位置信息。
my $f2 = "../../01_merge_coding_and_noncoding_mutation_id_cancer_type.txt";
my $fo1 = "./11_Cosmic_all_ref_alt_cancer.txt"; #能联系起来的mutation和cancer
my $fo2 = "./11_Cosmic_all_ref_alt_no_cancer.txt"; #不能和cancer联系起来的mutation
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header1 = "Chrom:pos.alt.ref\tMutation_id";
my $header = "$header1\tPrimary_site\tSite_subtype1\tSite_subtype2\tSite_subtype3\tHistology\tHist_subtype1";
$header = "$header\tHist_subtype2\tHist_subtype3";
print $O1 "$header\n";
print $O2 "$header1\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Chrom/){
         my $pos_info = $f[0];
         my $mutation_id = $f[1];
         $hash1{$mutation_id}=$pos_info;
         #print STDERR "123\n";
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_id/){
         my $mutation_id = $f[0];
         my $Primary_site = $f[1];
         my $Site_subtype_1 = $f[2];
         my $Site_subtype_2 = $f[3];
         my $Site_subtype_3 = $f[4];
         my $Primary_histology = $f[5];
         my $Histology_subtype_1 = $f[6];
         my $Histology_subtype_2 = $f[7];
         my $Histology_subtype_3 = $f[8];
         my $t = join "\t", @f[1..8];
         push @{$hash2{$mutation_id}},$t;
     }
}

foreach my $key (sort keys %hash1){
    if (exists $hash2{$key}){
        my @value = @{$hash2{$key}};
        my $s = $hash1{$key};
        foreach my $v(@value){
            my $k3 = "$s\t$key\t$v";
            unless(exists $hash3{$k3}){
                 print $O1 "$k3\n";
                 $hash3{$k3} = 1;
           } 
        }  
    }
    else{
        my $s = $hash1{$key};
        print $O2 "$s\t$key\n";
    }
}


