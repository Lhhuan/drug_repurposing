#将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel/pathogenic_hotspot/04_all_SV_and_CNV_pathogenic_hotspot_gene_oncotree.txt"
#和./02_data_used_calculate_for_repo_logistic_regression.txt merge在一起，得./021_add_sv_and_cnv_info_for_calculate_feature.txt,并去重排序得文件./021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;


my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel/pathogenic_hotspot/04_all_SV_and_CNV_pathogenic_hotspot_gene_oncotree.txt";
my $f2 = "./02_data_used_calculate_for_repo_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./021_add_sv_and_cnv_info_for_calculate_feature.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my $header = "Drug_chembl_id|Drug_claim_primary_name\tensg\tdrug_target_score\tcancer_oncotree_main_id\tmutation_id\tMap_to_gene_level\tcancer_specific_affected_donors\tCADD_MEANPHRED\tlogic\tmap_to_gene_level_score";
$header = "$header\tsv_or_cnv_type\tsv_or_cnv_id";
print $O1 "$header\n";

my (%hash1,%hash2,%hash3,%hash4,%hash8,%hash10,%hash13,%hash15,%hash16);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/#CHROM/){
        my @f =split/\t/;
        my $source = $f[9];
        my $ID = $f[10];
        my $ENSG = $f[11];
        my $oncotree_ID_main_tissue = $f[-1];
        my $k = "$oncotree_ID_main_tissue\t$ENSG"; 
        my $v = "$source\t$ID";
        push @{$hash1{$k}},$v;
    }
}



while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $ensg = $f[1];
        my $drug_target_score = $f[2];
        my $cancer_oncotree_main_id = $f[3];
        my $mutation_id = $f[4];
        my $Map_to_gene_level = $f[5];
        my $cancer_specific_affected_donors = $f[6];
        my $CADD_MEANPHRED = $f[7];
        my $logic = $f[8];
        my $map_to_gene_level_score = $f[9];
        my $k = "$cancer_oncotree_main_id\t$ensg";
       if(exists $hash1{$k}){
           my @sv_cnv_infos = @{$hash1{$k}};
           foreach my $sv_cnv_info(@sv_cnv_infos){
               my $output = "$_\t$sv_cnv_info";
               print $O1 "$output\n";
           }
       }
       else{
           my $output = "$_\tNA\tNA";
            print $O1 "$output\n";
       }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
system "sort ./021_add_sv_and_cnv_info_for_calculate_feature.txt | uniq >./021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt" ; #暂时注释