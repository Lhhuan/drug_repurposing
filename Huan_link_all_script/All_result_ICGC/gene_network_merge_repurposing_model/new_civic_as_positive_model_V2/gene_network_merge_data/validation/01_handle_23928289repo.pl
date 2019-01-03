#将./output/23928289repo.txt中的分号等去掉，并把drug 和repo cancer 分开输出得./output/01_handle_23928289repo.txt，得unique的cancer文件./output/01_23928289_unique_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;




my $f1 = "./data/23928289repo.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/01_handle_23928289repo.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/01_23928289_unique_cancer.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);
print $O1 "drug\trepo_cancer\n";
print $O2 "Cancer\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $Drug = $f[0];
        my $repo_cancer = $f[1];
        $repo_cancer =~ s/\(.*?$//g;
        $repo_cancer =~ s/"//g;
        my @cancers =split/,/,$repo_cancer;
        foreach my $cancer(@cancers){
            $cancer =~ s/^\s+//g;
            $cancer =~ s/\s+$//g;
            $cancer = lc($cancer);
            my $output1 = "$Drug\t$cancer";
            unless (exists $hash1{$output1}){
                $hash1{$output1} =1;
                print $O1 "$output1\n";
            }
            unless (exists $hash2{$cancer}){
                $hash2{$cancer}=1;
                print $O2 "$cancer\n";
            }
        }
    }
}
