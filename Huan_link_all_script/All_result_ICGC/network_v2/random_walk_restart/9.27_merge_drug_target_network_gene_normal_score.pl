#把08_drug_start_comma_end.txt 中的drug target id 用../04_map_ICGC_snv_indel_in_network_num.txt 转换成entrez id，并和9.26_drug_network_disease_gene_normal_score.txt 
#merge在一起，得 9.27_merge_drug_target_network_gene_normal_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./08_drug_start_comma_end.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="../04_map_ICGC_snv_indel_in_network_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 ="./9.26_drug_network_disease_gene_normal_score.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo2 ="./9.27_merge_drug_target_network_gene_normal_score.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "drug\tstart_id\tstart_entrez_id\trandom_overlap_fact_end\tnormal_score_p_value\n";
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
        my $start = $f[1];
        $hash1{$drug} = $start;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^entrezgene/){  #entrezgene和network_id转换
        my $gene = $f[0];
        my $network_id = $f[1];
        $hash2{$network_id}=$gene;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){  #基因与癌症的关系
        my $drug = $f[0];
        my $random_overlap_fact_end =$f[1];
        my $normal_score = $f[2];
        my $v= "$random_overlap_fact_end\t$normal_score";
        push @{$hash3{$drug}},$v;
    }
}

foreach my $drug (sort keys %hash1){
    my $start = $hash1{$drug};
    my @f =split/\,/,$start;
    my @start_entrez_id= ();
    foreach my $start_id(@f){
        if (exists $hash2{$start_id}){
            my $start_entrez = $hash2{$start_id};
            push @start_entrez_id, $start_entrez;
        }
    }
    my $out_gene = join(",",@start_entrez_id);
        if (exists $hash3{$drug}){
        my @drug_infos = @{$hash3{$drug}};
        foreach my $drug_info(@drug_infos){
            my $output = "$drug\t$start\t$out_gene\t$drug_info";
            unless(exists $hash4{$output} ){
                $hash4{$output} =1;
                print $O2 "$output\n";
            }
        }
    }
}

