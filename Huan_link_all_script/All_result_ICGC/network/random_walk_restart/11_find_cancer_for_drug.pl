#利用9.27_merge_drug_target_network_gene_normal_score.txt和../04_map_ICGC_snv_indel_in_network_num.txt 和致病性的突变与癌症关系的文件"/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt" ，
#得与每个药物有关系的cancer文件11_ICGC_snv_indel_network_drug_cancer.txt,得没有cancer 对应的gene 文件11_no_cancer_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./9.27_merge_drug_target_network_gene_normal_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="../04_map_ICGC_snv_indel_in_network_num.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 ="/f/mulinlab/huan/All_result_ICGC/pathogenicity_mutation_cancer/pathogenicity_mutation_cancer.txt"; #致病性的突变与癌症关系
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo2 ="./11_ICGC_snv_indel_network_drug_cancer.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo1 ="./11_no_cancer_entrez.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header ="drug\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
print $O2 "$header\n";
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
    unless(/^CADD_MEANPHRED/){  #基因（致病性突变）与癌症的关系
        my $CADD_MEANPHRED = $f[0];
        my $Mutation_ID = $f[1];
        my $ENSG =$f[2];
        my $Map_to_gene_level = $f[3];
        my $entrezgene = $f[4];
        my $project = $f[5];
        my $cancer_specific_affected_donors = $f[6];
        my $cancer_ID =$f[7];
        my $project_full_name = $f[8];
        my $project_full_name_from_project = $f[9];
        my $oncotree_term_detail = $f[10];
        my $oncotree_ID_detail =$f[11];
        my $oncotree_term_main_tissue =$f[12];
        my $oncotree_ID_main_tissue =$f[13];
        my $gene_role_in_cancer = $f[14];
        my $v = join("\t",@f[0..3],@f[5..14]);
        push @{$hash3{$entrezgene}},$v;
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
                        print $O2 "$out\n";
                    }
                }
            }
        }
        else{
            print $O1 "$entrez\n";
        }
        
    }
}
