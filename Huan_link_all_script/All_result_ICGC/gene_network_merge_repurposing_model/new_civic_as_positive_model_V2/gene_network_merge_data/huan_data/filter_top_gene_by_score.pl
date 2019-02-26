##对于./output/merge_gene_based_and_network_based_data_for_figure.txt中的每个drug 按照drug target选出gene based 和network based 的top gene,得./output/filter_top_gene_by_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/merge_gene_based_and_network_based_data_for_figure.txt";
my $fo1 = "./output/filter_top_gene_by_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug_chembl_id_Drug_claim_primary_name\tdata_source\tdrug_target_score\tdrug_ENSG\n";
my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_ENSG = $f[2];
        my $drug_target_score = $f[3];
        $drug_target_score =~s/NA/1/g; #drug target score 为NA设置为1
        my $data_source = $f[-1];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$data_source"; #这样可以将gene based 和network based区分开
        my $v = "$drug_target_score\t$drug_ENSG";
        # print "$drug_target_score\n";
        push @{$hash1{$k}},$v;
    }
}


#TOP 5
foreach my $k(sort keys %hash1){
    my @vs = @{$hash1{$k}};
    my %hash2;
    @vs = grep { ++$hash2{$_} < 2 }  @vs;
    my @sorted_vs = sort { $b cmp $a } @vs; #将数组内元素按照数字降序排序
    my $number_v = @sorted_vs;
    if ($number_v<=5){
        foreach my $v(@sorted_vs){
            print $O1 "$k\t$v\n";
        }
    }
    else{
        my @top_vs =@sorted_vs[0..4];
        foreach my $v(@top_vs){
            print $O1 "$k\t$v\n";
        }
    }
}

# #TOP_1
# foreach my $k(sort keys %hash1){
#     my @vs = @{$hash1{$k}};
#     my %hash2;
#     @vs = grep { ++$hash2{$_} < 2 }  @vs;
#     my @sorted_vs = sort { $b cmp $a } @vs; #将数组内元素按照数字降序排序
#     my $number_v = @sorted_vs;
#     my $v =$sorted_vs[0];
#     print $O1 "$k\t$v\n";
# }