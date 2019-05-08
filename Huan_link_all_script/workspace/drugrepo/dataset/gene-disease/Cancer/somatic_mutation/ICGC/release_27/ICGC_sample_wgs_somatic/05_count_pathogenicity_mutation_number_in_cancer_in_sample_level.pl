#利用./output/04_pathogenicity_sample_oncotree.txt 计算每个cancer中在sample level的平均致病性突变数目，
#得文件./output/05_ICGC_pathogenicity_mutation_number_in_cancer_in_sample_level.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;


my $f1 = "./output/04_pathogenicity_sample_oncotree.txt";
my $fo1 = "./output/05_ICGC_pathogenicity_mutation_number_in_cancer_in_sample_level.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "oncotree_id\tall_mutation_number\tsample_number\taverage_mutation_in_sample\ttype\n";

while(<$I1>)
{
    chomp;
    unless (/^file_id/){
        my @f = split/\t/;
        my $donor_id  = $f[1];
        my $Mutation_ID = $f[3];
        my $oncotree_detail_id = $f[4];
        my $oncotree_main_id= $f[5];
        my $v = "$donor_id\t$Mutation_ID";
        unless ($oncotree_detail_id eq $oncotree_main_id ){
            push @{$hash1{$oncotree_detail_id}},$v; #用于计算oncotree_detail_id的mutation数目
            push @{$hash2{$oncotree_detail_id}},$donor_id;#用于计算oncotree_detail_id的mutation数目
        }
        push @{$hash3{$oncotree_main_id}},$v;
        push @{$hash4{$oncotree_main_id}},$donor_id;
    }
}

my @details;
foreach my $detail_id (sort keys %hash1){ #用于计算oncotree_detail_id的mutation数目
    my @all_mutations=@{$hash1{$detail_id}};
    my %hash5;
    @all_mutations =grep{++$hash5{$_}<2} @all_mutations;
    my @samples = @{$hash2{$detail_id}};
    my %hash6;
    @samples = grep{++$hash6{$_}<2} @samples;
    my $all_mutation_number = @all_mutations;
    my $sample_number = @samples;
    my $average_mutation_in_sample = $all_mutation_number/ $sample_number;
    my $output = "$detail_id\t$all_mutation_number\t$sample_number\t$average_mutation_in_sample\toncotree_detail_id";
    print $O1 "$output\n";
    push @details, $average_mutation_in_sample;
}
#--------------------------------------------------#所有detail 平均的平均
my $detail_number = @details;
my $sum_detail = sum @details;
my $average_detail = $sum_detail/$detail_number;
print $O1 "average_detail_id\t$detail_number\t$sum_detail\t$average_detail\toncotree_detail_id\n" ;
#-----------------------------------
# print $O1 "oncotree_id\tall_mutation_number\tsample_number\taverage_mutation_in_sample\ttype\n";

my @mains;
foreach my $main_id (sort keys %hash3){ #用于计算oncotree_main_id的mutation数目
    my @all_mutations=@{$hash3{$main_id}};
    my %hash5;
    @all_mutations =grep{++$hash5{$_}<2} @all_mutations;
    my @samples = @{$hash4{$main_id}};
    my %hash6;
    @samples = grep{++$hash6{$_}<2} @samples;
    my $all_mutation_number = @all_mutations;
    my $sample_number = @samples;
    my $average_mutation_in_sample = $all_mutation_number/ $sample_number;
    my $output = "$main_id\t$all_mutation_number\t$sample_number\t$average_mutation_in_sample\toncotree_main_id";
    print $O1 "$output\n";
    push @mains,$average_mutation_in_sample;
}

#--------------------------------------------------#所有main 平均的平均
my $main_number = @mains;
my $sum_main = sum @mains;
my $average_main = $sum_main / $main_number;
print $O1 "average_main_id\t$main_number\t$sum_main\t$average_main\toncotree_main_id\n";