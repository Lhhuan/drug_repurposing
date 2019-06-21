#利用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_path_logical.txt"将./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt的最短路径逻辑文件提取，
#得./output/01_uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS_path_logic.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/10_start_end_path_logical.txt"; 
my $f2 ="./output/uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS.txt";
my $fo1 ="./output/01_uniq_CHEMBL25_MEL_KRAS_HRAS_NRAS_path_logic.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^start_tend/){
        my $start_tend = $f[0];
        my $path_logic_direction = $f[1];
        my $symbol_path_logic_direction =$f[2];
        my $v = "$path_logic_direction\t$symbol_path_logic_direction";
        $hash1{$start_tend}=$v;
    }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
    if (/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\tpath_node_logic\tsymbol_path_logic_direction\n";
    }
    else{
        my $the_shortest_path = $f[4];
        if (exists $hash1{$the_shortest_path}){
            my $path_logic_direction = $hash1{$the_shortest_path};
            print $O1 "$_\t$path_logic_direction\n";
        }
        else{
            print "$the_shortest_path\n";
        }
    }
}

