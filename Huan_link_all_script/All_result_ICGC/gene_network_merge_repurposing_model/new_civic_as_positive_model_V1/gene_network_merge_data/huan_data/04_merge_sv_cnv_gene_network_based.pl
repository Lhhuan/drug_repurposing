#把./output/03_unique_merge_gene_based_and_network_based_data.txt和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_all_sv_cnv_oncotree.txt"
#merge在一起，得./output/04_final_data_for_calculate_features.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_all_sv_cnv_oncotree.txt";
my $f2 = "./output/03_unique_merge_gene_based_and_network_based_data.txt";
my $fo1 = "./output/04_final_data_for_calculate_features.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID_detail\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score\tdata_source\tSVSCORETOP10\tsource\tID";
print $O1 "$header\n";

my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#CHROM/){
        my @f =split/\t/;
        my $SVSCORETOP10 = $f[4];
        my $source = $f[9];
        my $ID =$f[10];
        my $ENSG  =$f[11];
        my $oncotree_ID_detail = $f[13];
        my $oncotree_ID_main_tissue = $f[-1];
        unless($ENSG =~/NA/){
            my $k = "$oncotree_ID_detail\t$oncotree_ID_main_tissue\t$ENSG";
            my $v= "$SVSCORETOP10\t$source\t$ID";
            push @{$hash1{$k}},$v;
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
        my $cancer_ENSG = $f[12];
        my $oncotree_ID_detail = $f[13];
        my $oncotree_ID_main_tissue = $f[14];
        my $k = "$oncotree_ID_detail\t$oncotree_ID_main_tissue\t$cancer_ENSG";
        if (exists $hash1{$k}){
            my @sv_infos =@{$hash1{$k}};
            foreach my $sv_info(@sv_infos){
                my $output = "$_\t$sv_info";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
        else{
            my $output = "$_\tNA\tNA\tNA";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄