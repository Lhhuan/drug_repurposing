#把sorted_oncotree-id_mutation_num.txt里面number 小于10000的加起来作为一个other,得文件final_oncotree-id_mutation_num.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./sorted_oncotree-id_mutation_num.txt";
my $fo1 = "./final_oncotree-id_mutation_num.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my @other_num;
print $O1 "oncotree_id_label\tinvolve_mutationID_num\toncotree_id\n";

while(<$I1>)
{
    chomp;
    unless (/^involve_mutationID_num/){
        my @f = split/\t/;
        my $num=$f[0];
        my $oncotree = $f[1];
        if($num<10000){
            push @other_num,$num;
        }
        else{
            print $O1 "$oncotree=$num\t$num\t$oncotree\n";
        }
     }
}
my $sum = 0;
$sum += $_ foreach @other_num;
print $O1 "Other=$sum\t$sum\tOther\n";
