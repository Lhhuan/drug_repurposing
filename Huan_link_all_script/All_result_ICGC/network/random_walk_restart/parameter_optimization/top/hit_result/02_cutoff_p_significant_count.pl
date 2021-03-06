#把不同cutoff时，p值显著的drug repo pair计数。得文件02_cutoff_p_significant_count.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

 my $f1 ="./fisher_test_result_p_small_than0.05.txt";  
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2);

my $fo1 ="./02_cutoff_p_significant_count.txt"; #最终输出结果文件,在不同的cutoff下，rwr结果hit住每个drug repo的disease gene的个数
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cutoff\tdrug_repo_count\trecall_percentage\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^cutoff/){
        my $cutoff = $f[0];
        my $v =join("\t",@f[1..3]);
        push @{$hash1{$cutoff}},$v;
    }
}
foreach my $cutoff (sort keys %hash1){
    my @v = @{$hash1{$cutoff}};
    my %hash3;
    @v = grep { ++$hash3{$_} < 2 } @v; #对数组元素进行去重，
    my $count = @v;
    my $recall_percentage = $count/249*100;
    $recall_percentage=sprintf "%.2f",$recall_percentage;
    print $O1 "$cutoff\t$count\t$recall_percentage\n";
}