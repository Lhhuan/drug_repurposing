#利用../../all_drug_infos_score.txt和11_ICGC_snv_indel_network_drug_cancer.txt 联系起来，把drug原来的indication等信息加过来，得12_ICGC_snv_indel_network_drug_indication_cancer.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./11_ICGC_snv_indel_network_drug_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="../../all_drug_infos_score.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 ="./12_ICGC_snv_indel_network_drug_indication_cancer.txt"; 
 open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header ="drug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication";
$header = "$header\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail";
$header = "$header\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\tdrug_target_score";
print $O2 "$header\n";
 my %hash1;
 my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug_name = $f[0];
        $drug_name =uc($drug_name);
        $drug_name =~s/\s+/_/g;#为了建文件夹方便，把空格替换成_
        $drug_name =~s/"//g;#后面也是为了建文件夹方便
        $drug_name =~s/\(//g;
        $drug_name =~s/\)//g;
        $drug_name =~s/\//_/g;
        $drug_name =~s/\&/+/g; #把&替换+
        $drug_name =~s/-/_/g;

        push @{$hash1{$drug_name}},$_; #这里的end是network num id
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){  #entrezgene和network_id转换
        my $drug_name = $f[0];
        $drug_name =~s/\s+/_/g;#为了建文件夹方便，把空格替换成_
         $drug_name =~s/"//g;#后面也是为了建文件夹方便
         $drug_name =~s/\(//g;
         $drug_name =~s/\)//g;
         $drug_name =~s/\//_/g;
         $drug_name =~s/\&/+/g; #把&替换+
         $drug_name =~s/-/_/g;
        push @{$hash2{$drug_name}},$_;
    }
}

foreach my $drug (sort keys %hash1){
    my @oncotree_ids = @{$hash1{$drug}};
    my %hash3;
    @oncotree_ids = grep { ++$hash3{$_} < 2 } @oncotree_ids;
    if (exists $hash2{$drug}){
        my @drug_infos= @{$hash2{$drug}};
        my %hash4;
        @drug_infos = grep { ++$hash4{$_} < 2 } @drug_infos;
        foreach my $oncotree_id (@oncotree_ids){
            foreach my $drug_info(@drug_infos){
                print $O2 "$oncotree_id\t$drug_info\n";
            }
        }
    }
    else{
        print STDERR "$drug\n";
    }
}