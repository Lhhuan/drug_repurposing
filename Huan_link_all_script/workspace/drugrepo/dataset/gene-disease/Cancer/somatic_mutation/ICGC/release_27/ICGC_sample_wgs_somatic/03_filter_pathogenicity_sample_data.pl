#利用../release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt 筛选出./output/02_merge_mutation_donor_project.txt.gz的致病性突变
#得./output/03_pathogenicity_sample_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt";
my $f2 = "./output/02_merge_mutation_donor_project.txt.gz";
my $fo1 = "./output/03_pathogenicity_sample_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "chr\tpos\tref\talt\tfile_id\tdonor_id\tproject\tMutation_ID\n";

while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $Mutation_ID = $f[0];
        my $Chr = $f[1];
        my $Pos = $f[2];
        my $ref = $f[3];
        my $alt = $f[4];
        my $k =join(",",@f[1..4]);
        $hash1{$k}=$Mutation_ID;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^chr/){
        my @f =split/\t/;
        my $chr =$f[0];
        my $pos = $f[1];
        my $ref = $f[2];
        my $alt = $f[3];
        my $k = join (",",@f[0..3]);
        if (exists $hash1{$k}){
            my $Mutation_ID = $hash1{$k};
            my $output = "$_\t$Mutation_ID";
            print $O1 "$output\n";
        }
    }
}


