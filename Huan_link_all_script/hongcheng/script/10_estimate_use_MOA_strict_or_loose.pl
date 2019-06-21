#判断../output/09_normal_three_source_cancer_gene.txt中对于特定的cancer gene moa 是loose 还是strict，得文件../output/10_unique_cancer_gene_moa_rule.txt
#对原文件../output/09_normal_three_source_cancer_gene.txt 加label得../output/10_normal_three_source_cancer_gene_lable.txt
# Strict rule: B-SFIT direction should be same with cancer type effect (oncogene, or tumor suppressor, or both, if the cancer gene moa is unique in cancer types)
# Loose rule: B-SFIT direction may not be necessarily same with cancer type effect (oncogene, or tumor suppressor, or both), but B-SFIT direction is final MOA (if the cancer gene moa are not unique in cancer types)
# Free rule: do not care about cancer types, only use B-SFIT direction in the pancancer level
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/09_normal_three_source_cancer_gene.txt";
my $fo1 ="../output/10_unique_cancer_gene_moa_rule.txt"; 
my $fo2 ="../output/10_normal_three_source_cancer_gene_lable.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "Gene_symbol\tEntrez\tENSG\tMOA_rule\n";
print $O2 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tENSG\tnormal_MOA\tMOA_rule\n";
my(%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene_symbol/){
        my $Gene_symbol =$f[0];
        my $Entrez =$f[1];
        my $ENSG = $f[4];
        my $normal_MOA =$f[5];
        # print "$normal_MOA\n";
        my $k = "$Gene_symbol\t$Entrez\t$ENSG";
        push @{$hash1{$k}},$_;
        push @{$hash2{$k}},$normal_MOA;
    }
}

#----------------------------------------judge cancer gene moa role
my (%hash4,%hash5);
foreach my $k(sort keys %hash2){
    my @V2s = @{$hash2{$k}};
    my %hash3;
    @V2s = grep{++$hash3{$_}<2} @V2s;
    my $moa_number = @V2s ;
    if ($moa_number >1){ #一个gene 有多个moa
        print $O1 "$k\tLoose\n";
        $hash4{$k}="Loose";
    }
    else{ #一个gene有一个moa
        print $O1 "$k\tStrict\n";
        $hash4{$k}="Strict";
        # print "@V2s\n";
    }
}

#------------------------------------为原文件添加cancer gene moa role lable
foreach my $k (sort keys %hash4){
    my $v = $hash4{$k};
    if (exists $hash1{$k}){
        my @V1s = @{$hash1{$k}};
        foreach my $v1(@V1s){
            my $output = "$v1\t$v";
            print $O2 "$output\n";
        }
    }
    else{
        print "$k\n";
    }
}



