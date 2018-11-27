#计算merge_project_id_num_oncotree.txt文件里每个oncotree_id 对应的的num，得文件oncotree-id_mutation_num.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./merge_project_id_num_oncotree.txt";
my $fo1 = "./oncotree-id_mutation_num.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "involve_mutationID_num\toncotree_id\toncotree_id_label\n";

while(<$I1>)
{
    chomp;
    unless (/^involve_mutationID_num/){
        my @f = split/\t/;
        my $oncotree = $f[1];
        my $num=$f[0];
        push @{$hash1{$oncotree}},$num;
     }
}



foreach my $oncotree(sort keys %hash1){
    my @nums = @{$hash1{$oncotree}};
    my $sum = 0;
    $sum += $_ foreach  @nums;
    print $O1 "$sum\t$oncotree\t$oncotree=$sum\n";
}
