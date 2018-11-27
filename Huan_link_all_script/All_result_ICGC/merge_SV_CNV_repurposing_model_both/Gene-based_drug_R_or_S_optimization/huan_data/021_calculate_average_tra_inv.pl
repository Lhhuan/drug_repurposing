#将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt"
#和./02_data_used_calculate_for_repo_logistic_regression.txt merge在一起，计算drug cancer pair 中的cancer gene在inv_tra中的average gene,得文件./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt,
#并得drug cancer pair 中的cancer gene在存在的具体hotspot，及和具体Hotspot的那个gene 有overlap,得文件"./output/021_drug_cancer_pair_in_inv_tra.txt"
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;



# my $f1 = "./123.txt";
# my $f2 = "./1234.txt";
my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";
my $f2 = "./02_data_used_calculate_for_repo_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/021_drug_cancer_pair_average_gene_in_inv_tra.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo3 = "./output/021_drug_cancer_pair_in_inv_tra.txt"; ##输出存在hotspot 的gene中间结果，
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";


print $O1 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID_main_tissue\taverage_gene_in_INV\taverage_gene_in_tra\n";
print $O3 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID_main_tissue\tin_ENSG1\tin_ENSG2\tsource\tID\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/#CHROM1/){
        my @f =split/\t/;
        my $ENSG1 = $f[3];
        my $ENSG2 = $f[7];
        if($ENSG1!~/NA/ && $ENSG2 !~/NA/){ #cancer gene 必须在INV和TRA的两端的Hotspot都存在，才算是存在hotspot中，所以只要有一端是NA ,都不是合适的Hotspot
            my $source = $f[13];
            my $ID = $f[14];
            my $oncotree_ID_main_tissue = $f[-1];
            my $v = "$ENSG1\t$ENSG2\t$source\t$ID";
            push @{$hash1{$oncotree_ID_main_tissue}},$v;
        }
    }
}



while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];      
        my $cancer_ENSG = $f[1];
        my $oncotree_ID_main_tissue =$f[3];
        my $logic = $f[8];
        if ($logic =~/true/){
            if(exists $hash1{$oncotree_ID_main_tissue}){
                my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue";
                push @{$hash2{$k}},$cancer_ENSG;
            }
            else{  #没有inv,tra的drug cancer pair的average gene in INV 和tra 都是0
                my $out = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID_main_tissue\t0\t0";
                unless (exists $hash4{$out}){
                    $hash4{$out} =1;
                    print $O1 "$out\n";
                }
            }
        }
    }
}


foreach my $drug_cancer(sort keys %hash2){
    my @f1 =split/\t/,$drug_cancer;
    my $drug = $f1[0];
    my $repo_cancer = $f1[1];
    if (exists $hash1{$repo_cancer}){
        my @cancer_ENSGs = @{$hash2{$drug_cancer}};
        my %hash5;
        @cancer_ENSGs = grep { ++$hash5{$_} < 2 } @cancer_ENSGs; #对数组内元素进行去重
        my @source_id_ENSG_infos = @{$hash1{$repo_cancer}};
        my @all_gene_in_inv_hotspot_num_array = (); #存放cancer gene在不同inv_hotspot中出现的个数
        my @all_gene_in_tra_hotspot_num_array = (); #存放cancer gene在不同tra_hotspot中出现的个数
        foreach my $source_id_ENSG_info(@source_id_ENSG_infos){
            my @f2 =split/\t/,$source_id_ENSG_info;
            my $ENSG1 = $f2[0];
            my $ENSG2 = $f2[1];
            my $source = $f2[2];
            my $ID = $f2[3];
            my @ENSG1_array = split/,/,$ENSG1;
            my @ENSG2_array = split/,/,$ENSG2;
            my @gene_in_ENSG1 =(); #用来记录落在@ENSG1_array中的cancer gene数目
            my @gene_in_ENSG2 =(); #用来记录落在@ENSG2_array中的cancer gene数目
            foreach my $cancer_ENSG(@cancer_ENSGs){
                if(grep /$cancer_ENSG/, @ENSG1_array ){  #捕获在@ENSG1_array里出现的$cancer_ENSG
                    push @gene_in_ENSG1,$cancer_ENSG
                }
                if(grep /$cancer_ENSG/, @ENSG2_array ){ 
                    push @gene_in_ENSG2,$cancer_ENSG
                }
            }
            my $length_gene_in_ENSG1 = @gene_in_ENSG1;
            my $length_gene_in_ENSG2 = @gene_in_ENSG2;
            if ($length_gene_in_ENSG1>0 && $length_gene_in_ENSG2 >0){ #cancer gene 必须在INV和TRA的两端的Hotspot都存在，才算是存在hotspot中
                my $out_ENSG1 = join(",",@gene_in_ENSG1);
                my $out_ENSG2 = join(",",@gene_in_ENSG2);
                my $output1 = "$drug_cancer\t$out_ENSG1\t$out_ENSG2\t$source\t$ID";
                print $O3 "$output1\n"; #输出中间结果，用于检查。
                my $num = $length_gene_in_ENSG1+$length_gene_in_ENSG2;
                if ($source=~/inv_svscore/){
                    push @all_gene_in_inv_hotspot_num_array,$num;
                }
                elsif($source=~/tra_svscore/){
                    push @all_gene_in_tra_hotspot_num_array,$num;
                }
            } 
        }
        my $num_of_cancer_gene = @cancer_ENSGs;
        my $sum_inv= 0;
        $sum_inv += $_ foreach @all_gene_in_inv_hotspot_num_array;
        my $sum_tra= 0;
        $sum_tra += $_ foreach @all_gene_in_tra_hotspot_num_array;
        my $average_inv = $sum_inv/$num_of_cancer_gene;
        my $average_tra = $sum_tra/$num_of_cancer_gene;
        my $out_final = "$drug_cancer\t$average_inv\t$average_tra";
        print $O1 "$out_final\n";
    }
}
