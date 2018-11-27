#用cancer_id_full_oncotree.txt为project_id_num.txt文件添加oncotree信息。得文件merge_project_id_num_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./project_id_num.txt";
my $f2 = "./cancer_id_full_oncotree.txt";
my $fo1 = "./merge_project_id_num_oncotree.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "involve_mutationID_num\toncotree_id\tproject\n";

while(<$I1>)
{
    chomp;
    unless (/^project/){
        my @f = split/\t/;
        my $project = $f[0];
        my $num=$f[1];
        $hash1{$project}=$num;
     }
}


while(<$I2>)
{
    chomp;
    unless (/^term/){
        my @f = split/\t/;
        my $project = $f[1];
        my $oncotree_ID=$f[-1];
        $hash2{$project}=$oncotree_ID;
     }
}

foreach my $project(sort keys %hash1){
    my $num = $hash1{$project};
    my $oncotree_ID = $hash2{$project};
    print $O1 "$num\t$oncotree_ID\t$project\n";

}
