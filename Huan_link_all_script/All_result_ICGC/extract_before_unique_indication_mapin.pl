#利用refine_huan_used_mapin_id.txt 在huan_mapin_do_hpo_oncotree_main1.txt提取unique 的mapin 结果，最终得到huan_mapin_do_hpo_oncotree_before.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./refine_huan_used_mapin_id.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
#my $f2 ="./DGIdb_used_mapin.txt";
my $f2 ="./huan_mapin_do_hpo_oncotree_main1.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./huan_mapin_do_hpo_oncotree_before.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Indication_ID/){
        my $ID = $f[0];
        my $indication = $f[-1];
        $indication =~s/"//g;
        $indication=lc($indication);
        $indication =~s/^\s+//g;
        $hash1{$ID}=$indication;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     if(/^Indication_ID/){
         print $O1 "$_\n";
     }
     else{
        my $ID = $f[0];
        my $v= join("\t",@f[2..9]);
        $hash2{$ID}=$v;
     }
}

foreach my $ID (sort keys %hash1){
    if(exists $hash2{$ID}){
        my $indication = $hash1{$ID};
        my $mapin= $hash2{$ID};
        my $output = "$ID\t$indication\t$mapin";
        print $O1 "$output\n";
    }
}