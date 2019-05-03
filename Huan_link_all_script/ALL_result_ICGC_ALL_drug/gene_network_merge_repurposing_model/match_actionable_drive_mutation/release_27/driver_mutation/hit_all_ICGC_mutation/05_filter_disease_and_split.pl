#将不在ICGC的文件./output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt根据疾病进行过滤，并将疾病进行split，得./output/05_ont_in_ICGC_filter_disease.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt";
my $fo1 = "./output/05_out_in_ICGC_filter_disease.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "variant_id\tfinal_variant\thgvsg\tdisease";
print  $O1 "$header\n";



while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        my $variant_id = $f[0];
        my $final_variant =$f[1];
        my $hgvsg = $f[2];
        my $disease = $f[3];
        unless($disease =~/\bNA\b/){
            my @diseases = split/\,/,$disease;
            foreach my $d(@diseases){
                my $output= "$variant_id\t$final_variant\t$hgvsg\t$d";
                unless (exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}


