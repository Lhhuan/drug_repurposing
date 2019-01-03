#从repoDB_full.csv中筛出indication 为cancer的信息。得被Terminated_or_Withdrawn的cancer drug info文件./output/05_filter_cancer_from_repoDB_negative.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./data/repoDB_full.csv";
my $fo1 ="./output/05_filter_cancer_from_repoDB_negative.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug_name\tdisease\tstatus\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8);
while(<$I1>)
{
    chomp;
    my @f= split /\,/;
    my $disease =$f[2];
    my $status= $f[5];
    my $drug_name = $f[0];
    my $k= "$drug_name\t$disease\t$status";
    $k =~s/"//g;
    unless(/^drug_name/){
        my $disease =$f[2];
        my $status= $f[5];
        if ($disease=~ /cancer|tumor|oma|Neoplasm|Neoplasia/i){
            if($status =~/Terminated|Withdrawn/){
                print $O1 "$k\n";
            }
        }
    }
}

#----------------------------------------------------------
