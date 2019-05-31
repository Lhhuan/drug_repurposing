#将不在./output/normal_three_source_gene_role.txt 中的./output/cancermine_collated_and_ensg_symbol.txt和./output/normal_three_source_gene_role.txt merge 到一起
#得./output/normal_four_source_gene_role.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/normal_three_source_gene_role.txt";
my $f2 ="./output/cancermine_collated_and_ensg_symbol.txt";
my $fo1 ="./output/four_cancer_gene.txt";
my $fo2 ="./output/driver_cancer_gene.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my(%hash1,%hash2,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^symbol/){
       print $O1 "$_\n"; 
    }
    else{
        my $ensg = $f[-1];
        my $source = $f[-2];
        unless($source =~/oncodriverole/){
            $hash1{$ensg}=1;
            print $O1 "$_\n";
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^role/){
        my $role = $f[0];
        my $citation_number = $f[-3];
        my $ensg = $f[-2];
        my $symbol = $f[-1];
        if($role =~/Driver/){ #role 标记为gof或者lof的才进来
            my $k = "$ensg\t$symbol";
            unless(exists $hash1{$ensg}){
                push @{$hash4{$k}},$citation_number;
            }
        }
        else{
            unless(exists $hash1{$ensg}){ #不在之前的source中存在的基因
                my $k = "$ensg\t$symbol";
                push @{$hash2{$k}},$role;
            }
        }
    }
}

foreach my $k(sort keys %hash2){
    my @f=split/\t/,$k;
    my $ensg = $f[0];
    my $symbol = $f[1];
    my @vs = @{$hash2{$k}};
    my %hash3;
    @vs = grep {++$hash3{$_}<2}@vs;
    my $number = @vs;
    if ($number<2){ #按照./output/normal_three_source_gene_role.txt 的格式输出， #有一种作用
        my $role = $vs[0];
        print $O1 "$symbol\tNA\tNA\t$role\tcancermine\t$ensg\n";
    }
    else{ #有两种作用，输出两种
        my $role = "LOF,GOF";
        print $O1 "$symbol\tNA\tNA\t$role\tcancermine\t$ensg\n";
    }
}


foreach my $k(sort keys %hash4){
    unless(exists $hash2{$k}){
        my @vs = @{$hash4{$k}};
        my %hash5;
        @vs=grep {++$hash5{$_}<2}@vs;
        my @sorted_vs = sort {$a <=> $b} @vs; #将数组内元素按照数字降序排列
        my $number = $sorted_vs[0];
        print $O2 "$k\t$number\n";
    }
}