#把./output/03_unique_merge_gene_based_and_network_based_data.txt和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt"
#merge在一起，得./output/04_final_data_for_calculate_features.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/05_merge_all_cnv_sv_project.txt";
my $f2 = "./output/03_unique_merge_gene_based_and_network_based_data.txt";
my $fo1 = "./output/04_final_data_for_calculate_features.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID_detail\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tproject\tmap_to_gene_level_score\tdata_source\tsv_source\tSVTYPE\tsv_ID\tSVSCORETOP10";




print $O1 "$header\n";

my (%hash1,%hash3);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#CHROM/){
        my @f =split/\t/;
        my $PROJECT = $f[0];
        my $source = $f[1];
        my $SVTYPE =$f[2];
        my $ID  =$f[3];
        my $SVSCORETOP10 = $f[4];
        my @projects = split /\,/,$PROJECT;
        foreach my $project (@projects){
            my $v = "$source\t$SVTYPE\t$ID\t$SVSCORETOP10";
            push @{$hash1{$project}},$v;
        }
    }
}



while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $project = $f[-3];
        if (exists $hash1{$project}){
            my @sv_cnvs = @{$hash1{$project}};
            my %hash2;
            @sv_cnvs = grep { ++$hash2{$_} < 2 } @sv_cnvs;
            foreach my $sv_cnv(@sv_cnvs){
                my $output = "$_\t$sv_cnv";
                print $O1 "$output\n";
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄