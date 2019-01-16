#根据./output/07_filter_snv_in_huan.txt中的mutation_id,
#利用"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf"将mutation的具体信息和./output/07_filter_snv_in_huan.txt连起来
#得./output/11_01_snv_in_huan_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

# my $f1 = "./snv_test_c.txt";
# open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# my $f2 = "./cnv_test_c.txt";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf";
my $f2 = "./output/07_filter_snv_in_huan.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/11_01_snv_in_huan_info.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $output = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\tpaper_sample_name\toncotree_id\toncotree_id_type\tMutation_ID\tchr\tpos\tref\talt\tchr:g.posref>alt\tdrug_entrze\tdrug_ENSG\tdrug_target_score";
$output = "$output\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED\tcancer_ENSG\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score";
$output= "$output\tdata_source";
print $O1 "$output\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30,%hash32);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $chr = $f[0];
        my $pos= $f[1];
        my $Mutation_ID = $f[2];
        my $ref = $f[3];
        my $alt = $f[4];
        my $position_type = "chr${chr}:g.${pos}${ref}>${alt}";
        my $v = "$chr\t$pos\t$ref\t$alt\t$position_type";
        $hash1{$Mutation_ID}=$v;
    }
}




while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $oncotree_id = $f[1];
        my $Mutation_ID = $f[2];
        my $drug_entrze = $f[3];
        my $drug_ENSG = $f[4];
        my $drug_target_score = $f[5];
        my $end_entrze = $f[6];
        my $the_shortest_path = $f[7];
        my $path_length = $f[8];
        my $normal_score_P = $f[9];
        my $cancer_specific_affected_donors = $f[11];
        my $original_cancer_ID = $f[12];
        #--------------------------------------------
        my $CADD_MEANPHRED = $f[13];
        my $cancer_ENSG = $f[14];
        my $the_final_logic = $f[15];
        my $Map_to_gene_level = $f[16];
        my $map_to_gene_level_score = $f[17];
        my $data_source = $f[18];
        my $oncotree_id_type = $f[19];
        my $drug_in_paper = $f[20];
        my $paper_sample_name = $f[21];
        if (exists $hash1{$Mutation_ID}){
            my $Mutation_info = $hash1{$Mutation_ID};
            my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$drug_in_paper\t$paper_sample_name\t$oncotree_id\t$oncotree_id_type\t$Mutation_ID\t$Mutation_info\t$drug_entrze\t$drug_ENSG\t$drug_target_score";
            $output = "$output\t$end_entrze\t$the_shortest_path\t$path_length\t$normal_score_P\t$cancer_specific_affected_donors\t$original_cancer_ID\t$CADD_MEANPHRED\t$cancer_ENSG\t$the_final_logic\t$Map_to_gene_level\t$map_to_gene_level_score";
            $output= "$output\t$data_source";
            unless (exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        else{
            print STDERR "$Mutation_ID\n";
        }
    }
}




