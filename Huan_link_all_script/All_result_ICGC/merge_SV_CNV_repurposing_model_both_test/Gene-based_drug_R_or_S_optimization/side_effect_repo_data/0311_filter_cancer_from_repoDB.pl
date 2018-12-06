#从repoDB_full.csv中筛出indication 为cancer的信息。得approved的cancer drug info文件0311_filter_cancer_from_repoDB_approved.txt，得被Terminated_or_Withdrawn的cancer drug info文件0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./repoDB_full.csv";
my $fo1 ="./0311_filter_cancer_from_repoDB_approved.txt"; 
my $fo2 ="./0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "drug_name\tdisease\tstatus\n";
print $O2 "drug_name\tdisease\tstatus\n";
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
            if($status =~/Approved/){
                print $O1 "$k\n";
            }
            elsif($status =~/Terminated|Withdrawn/){
                print $O2 "$k\n";
            }
        }
    }
}

#----------------------------------------------------------
