##利用/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/9.27_merge_drug_target_network_gene_normal_score.txt和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt"
#和突变与癌症关系的文件./output/02_merge_mutation_gene_MOA_and_cancer.txt
#得与mutation和drug关系的文件./output/05_network_drug_mutation.txt,得没有mutation 对应的gene 文件./output/05_no_mutation_cancer_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/9.27_merge_drug_target_network_gene_normal_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 ="./output/02_merge_mutation_gene_MOA_and_cancer.txt"; #致病性的突变与癌症关系
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 ="./output/05_network_drug_mutation.txt"; 
my $fo2 ="./output/05_no_mutation_cancer_entrez.txt"; #没有mutation cancer 信息的entrez gene
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $header= "drug\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P"; #network
$header = "$header\tcancer_entrez"; #
$header = "$header\tVariant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule"; #mutation
print $O1 "$header\n";
my %hash1;
my %hash2;
my %hash3;
my %hash4;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug = $f[0];
        my $start_id = $f[1];
        my $start_entrez = $f[2];
        my $random_overlap_fact_end = $f[3];
        my $normal_score_P = $f[4];
        my $v = "$drug\t$start_id\t$start_entrez\t$random_overlap_fact_end\t$normal_score_P";
        push @{$hash1{$random_overlap_fact_end}},$v; #这里的end是network num id
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^gene_symbol/){  #entrezgene和network_id转换
        my $gene = $f[1];
        my $network_id = $f[2];
        $hash2{$network_id}=$gene;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Variant_id/){  #mutation 与cancer gene的关系
        my $Entrez = $f[6];
        push @{$hash3{$Entrez}},$_;
    }
}

foreach my $end_id (sort keys %hash1){
    my @vs = @{$hash1{$end_id}};
    my %hash5;
    @vs = grep { ++$hash5{$_} < 2 } @vs;
    if (exists $hash2{$end_id}){
        my $entrez = $hash2{$end_id};
        if (exists $hash3{$entrez}){
            my @oncotree_ids = @{$hash3{$entrez}};
            my %hash6;
            @oncotree_ids = grep { ++$hash6{$_} < 2 } @oncotree_ids;
            foreach my $oncotree_id(@oncotree_ids){
                foreach my $v(@vs){
                    my $out = "$v\t$entrez\t$oncotree_id";
                    unless(exists $hash4{$out}){
                        $hash4{$out} =1 ;
                        print $O1 "$out\n";
                    }
                }
            }
        }
        else{
            print $O2 "$entrez\n";
        }
        
    }
}
