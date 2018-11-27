#将"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel/pathogenic_hotspot/04_all_SV_and_CNV_pathogenic_hotspot_gene_oncotree.txt"
#和./output/02_filter_infos_for_calculate_feature.txt merge在一起，得./output/021_add_sv_and_cnv_info_for_calculate_feature.txt,并去重排序得文件./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;



# my $f1 = "./123.txt";
# my $f2 = "./1234.txt";
my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel/pathogenic_hotspot/04_all_SV_and_CNV_pathogenic_hotspot_gene_oncotree.txt";
my $f2 = "./output/unique_02_filter_infos_for_calculate_feature.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/021_add_sv_and_cnv_info_for_calculate_feature.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score\tsv_or_cnv_type\tsv_or_cnv_id";
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
        my $Drug_claim_primary_name = $f[1];
        my $drug_entrze = $f[2];
        my $drug_ENSG = $f[3];
        my $drug_target_score = $f[4];
        my $end_entrze = $f[5];
        my $the_shortest_path = $f[6];
        my $path_length = $f[7];
        my $normal_score_P = $f[8];
        my $Mutation_ID = $f[9];
        my $cancer_specific_affected_donors = $f[10];
        my $CADD_MEANPHRED = $f[11];
        my $cancer_ENSG = $f[12];
        my $oncotree_ID_main_tissue =$f[13];
        my $the_final_logic = $f[14];
        my $Map_to_gene_level = $f[15];
        my $map_to_gene_level_score = $f[16];
        my $k = "$oncotree_ID_main_tissue\t$cancer_ENSG";
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
system "sort ./output/021_add_sv_and_cnv_info_for_calculate_feature.txt | uniq >./output/021_sorted_add_sv_and_cnv_info_for_calculate_feature.txt" ; #暂时注释