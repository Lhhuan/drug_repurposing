#把16_gene_based_ICGC_somatic_repo_may_success.txt文件的在indication里出现的cancer滤掉，得文件有可能repo成功的repo drug pairs 文件17_drug_repo_cancer_pairs_may_success.txt 得drug不可以repo的cancer文件17_drug_repo_cancer_pairs_may_fail.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./16_gene_based_ICGC_somatic_repo_may_success.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $fo1 ="./17_drug_repo_cancer_pairs_may_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./17_drug_repo_cancer_pairs_may_fail.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
# my $title ="Mutation_ID\tMap_to_gene_level\tentrezgene\tproject\tcancer_ID\tproject_full_name\toncotree_term\toncotree_ID\tgene_role_in_cancer";
# $title = "$title\tDrug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
# $title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
# $title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
# $title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication-OncoTree_term\tindication-OncoTree_IDs";
my $title = "drug\trepo_cancer";
print $O1 "$title\n";
print $O2 "$title\n";


my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^Mutation_ID/){
        my @f= split /\t/;
        my $drug = $f[10];
        my $indication = $f[-1];
        $indication =~ s/"//g;
        my $cancer = $f[8];
        my $k = "$drug\t$indication\t$cancer";
        push @{$hash1{$drug}},$indication;
        push @{$hash2{$drug}},$cancer;
    }
}

foreach my $drug (sort keys %hash1){
    my @indications = @{$hash1{$drug}};
    my %hash5;
     @indications = grep { ++$hash5{$_} < 2 } @indications;  #对数组内元素去重
    my @cancers = @{$hash2{$drug}};
    my %hash6;
    @cancers = grep { ++$hash6{$_} < 2 } @cancers;  #对数组内元素去重
    my $num =  @cancers ;
    #print STDERR "$num\n";
    foreach my $cancer(@cancers){
        if(grep /$cancer/, @indications ){  #捕获在indication里没有出现的cancer
         my $out = "$drug\t$cancer";
         unless(exists $hash3{$out}){
             $hash3{$out}=1;
             print $O2 "$out\n";
         }
        }
        else{
            my $out = "$drug\t$cancer";
            unless(exists $hash4{$out}){
                $hash4{$out}=1;
                print $O1 "$out\n";
         }
        }
       
    }
    
}


