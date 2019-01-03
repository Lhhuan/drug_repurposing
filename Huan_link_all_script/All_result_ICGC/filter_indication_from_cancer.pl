#把gene_based_somatic_repo_may_success.txt文件的在indication里出现的cancer滤掉，得文件gene_based_somatic_repo_may_success_cancer.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./gene_based_somatic_repo_may_success.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $fo1 ="./gene_based_somatic_repo_may_success_filter_cancer.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Chrom:pos.ref.alt\tMutation_id\tSymbol\tEntrez_ID\tRole_in_cancer\tDrug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication-OncoTree_term\tindication-OncoTree_IDs\tPrimary_site|Site_subtype1|Site_subtype2|Site_subtype3|Histology|Hist_subtype1|Hist_subtype2|Hist_subtype3\tratio";
$title = "$title\tcancer-OncoTree_term\tcancer-OncoTree_IDs";
print $O1 "$title\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $drug = $f[5];
    my $indication = $f[33];
    my $cancer = $f[-1];
    my $k = "$drug\t$indication\t$cancer";
    push @{$hash1{$drug}},$indication;
    push @{$hash2{$drug}},$cancer;
    push @{$hash3{$k}},$_;
}

foreach my $k (sort keys %hash3){
    my @infos = @{$hash3{$k}};
    my @f= split/\t/,$k;
    my $drug = $f[0];
    my $cancer1 = $f[2];
    my @indications = @{$hash1{$drug}};
    my @cancers = @{$hash2{$drug}};
    foreach my $info(@infos){
        foreach my $cancer(@cancers){
            unless(grep /^$cancer/, @indications ){  #捕获在indication里没有出现的cancer
                if($cancer eq $cancer1){
                    my $v = $info;
                    unless(exists $hash4{$v}){
                    print $O1 "$v\n";
                    $hash4{$v} = 1;

                    } 
                }
            }
        }
       
    }
    
}
