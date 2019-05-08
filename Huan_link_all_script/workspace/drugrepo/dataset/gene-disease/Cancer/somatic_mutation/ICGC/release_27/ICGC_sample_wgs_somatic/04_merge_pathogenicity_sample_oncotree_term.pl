#把./output/03_pathogenicity_sample_data.txt和 ../release_27_snv_indel/data_statistics/cancer_id_full_oncotree1.txt merge 在一起，
#得./output/pathogenicity_sample_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../release_27_snv_indel/data_statistics/cancer_id_full_oncotree1.txt";
my $f2 = "./output/03_pathogenicity_sample_data.txt";
my $fo1 = "./output/04_pathogenicity_sample_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "file_id\tdonor_id\tproject\tMutation_ID\toncotree_detail_id\toncotree_main_id\n";

while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $project  = $f[1];
        my $oncotree_detail_id = $f[6];
        my $oncotree_main_id= $f[8];
        my $v= "$oncotree_detail_id\t$oncotree_main_id";
        $hash1{$project}=$v;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^chr/){
        my @f =split/\t/;
        my $project  = $f[-2];
        my $w_out= join("\t",@f[4..7]);
        if (exists $hash1{$project}){
            my $oncotree = $hash1{$project};
            my $output = "$w_out\t$oncotree";
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}


