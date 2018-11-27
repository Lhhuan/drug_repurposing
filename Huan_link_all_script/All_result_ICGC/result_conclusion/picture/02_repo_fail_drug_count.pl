#记录../../17_drug_repo_cancer_pairs_may_fail.txt 里每个drug repo 到的cancer，与其原本indication的overlap. 得02_repo_fail_drug_count.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./../../17_drug_repo_cancer_pairs_may_fail.txt";
my $fo1 ="./02_repo_fail_drug_count.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug\tdrug_num\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^drug/){
        my $cancer = $f[1];
        my $drug = $f[0];
        push @{$hash1{$drug}},$cancer;
     }
}

foreach my $drug(sort keys %hash1){
    my @cancer = @{$hash1{$drug}};
    my $num = @cancer;
    print $O1 "$drug\t$num\n";
}


