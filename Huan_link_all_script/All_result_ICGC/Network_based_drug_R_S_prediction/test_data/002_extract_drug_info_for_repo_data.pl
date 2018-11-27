#在../all_drug_infos_score.txt中提取./output/001_merge_repoDB_oncotree.txt中的drug target 及其score等信息，得./output/002_drug_info_repo.txt,得具有以上的信息的文件./output/002_uni_drug_repo.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../all_drug_infos_score.txt";
my $f2 ="./output/001_merge_repoDB_oncotree.txt";
my $fo1 ="./output/002_drug_info_repo.txt"; 
my $fo2 ="./output/002_uni_drug_repo.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "Drug_claim_primary_name\tgene_symbol\tEntrez_id\tmoa\tENSG_ID\tdrug_type\tDrug_target_score\toncotree_main_ID\tstatus\n";
print $O2 "drug\toncotree_main_ID\tstatus\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $gene_symbol= $f[1];
        my $Entrez_id = $f[2];
        my $Drug_claim_primary_name = $f[4];
        $Drug_claim_primary_name = lc($Drug_claim_primary_name);
        my $moa = $f[3];
        my $ENSG_ID = $f[14];
        my $drug_type = $f[17];
        my $Drug_target_score = $f[-1];
        my $v= "$gene_symbol\t$Entrez_id\t$moa\t$ENSG_ID\t$drug_type\t$Drug_target_score";
        push @{$hash1{$Drug_claim_primary_name}},$v;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug= $f[0];
        $drug =lc($drug);
        my $status = $f[1];
        my $oncotree_main_ID = $f[2];
        my $v = "$oncotree_main_ID\t$status";
        push @{$hash2{$drug}},$v;
    }
}

foreach my $drug (sort keys %hash1){
    my @drug_infos =@{$hash1{$drug}};
    if(exists $hash2{$drug}){
        my @repo_sideeffects = @{$hash2{$drug}};
        foreach my $drug_info(@drug_infos){
            foreach my $repo_sideeffect(@repo_sideeffects){
                my $output = "$drug\t$drug_info\t$repo_sideeffect";
                unless(exists $hash3{$output}){
                    $hash3{$output} =1;
                    print $O1 "$output\n";
                }
                my $output2 = "$drug\t$repo_sideeffect";
                unless(exists $hash4{$output2}){
                    $hash4{$output2} =1;
                    print $O2 "$output2\n";
                }
            }
        }
    }
}