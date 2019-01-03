#将./output/04_drug_cancer.txt和./output/06_megre_negative_cancer_oncotree.txt merge 在一起，得./output/07_merge_positive_and_negative.txt
#并将./output/07_merge_positive_and_negative.txt中的 drug cancer pair 中即对应positive又对应negative筛掉，得./output/07_final_positive_and_negative.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/04_drug_cancer.txt";
my $f2 ="./output/06_megre_negative_cancer_oncotree.txt";
my $fo1 ="./output/07_merge_positive_and_negative.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tsample_type\tdrug_repurposing\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
       my $output = "$_\tpositive\t1";
       print $O1 "$output\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
       my $output = "$_\tnegative\t0";
       print $O1 "$output\n";
    }
}



close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 ="./output/07_merge_positive_and_negative.txt";
my $fo2 ="./output/07_final_positive_and_negative.txt";

open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print  $O2 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tsample_type\tdrug_repurposing\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
       my $k = join("\t",@f[0..4]); #drug cancer pair;
       my $v= "$f[5]\t$f[6]"; #sample type
       push @{$hash1{$k}},$v;
    }
}


foreach my $pair (sort keys %hash1){
    my @values = @{$hash1{$pair}};
    my $num = @values;
    unless ($num >1){ #drug cancer pair 中即对应positive又对应negative筛掉
        my $value = $values[0]; #此时的数组里面也就又一个值；
        my $output = "$pair\t$value";
        print $O2 "$output\n";
    }
}