#把0311_Terminated_or_Withdrawn_oncotree.txt 和0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt merge 成一个文件，得0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn.txt";
my $f2 ="./0311_Terminated_or_Withdrawn_oncotree.txt";
my $fo1 ="./0311_filter_cancer_from_repoDB_Terminated_or_Withdrawn_oncotree.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "drug_name\tstatus\tdisease\toncotree_main_ID\n";
my (%hash1,%hash2,%hash3,%hash4,%hash8);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $disease =$f[1];
    my $status= $f[2];
    my $drug_name = $f[0];
    my $v= "$drug_name\t$status";
    unless(/^drug_name/){
        push @{$hash1{$disease}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $disease =$f[0];
    my $oncotree_main_ID = $f[1];
    unless(/^drug_name/){
        unless($oncotree_main_ID =~/NA/){
            $hash2{$disease}= $oncotree_main_ID;
        }
    }
}

foreach my $disease(sort keys %hash1){
    my @vs = @{$hash1{$disease}};
    if(exists $hash2{$disease}){
        my $oncotree_main_ID = $hash2{$disease};
        foreach my $v (@vs){
            my $output = "$v\t$disease\t$oncotree_main_ID";
            unless(exists $hash3{$output}){
                $hash3{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}


#----------------------------------------------------------
