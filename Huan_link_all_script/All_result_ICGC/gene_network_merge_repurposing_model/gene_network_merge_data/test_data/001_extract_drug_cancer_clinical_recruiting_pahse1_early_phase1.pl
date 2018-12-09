#把经过recruiting,not yet recruiting, active not recruiting,early phase1, phase1 cancer这些条件筛选后，
#得./output/SearchResults.tsv ,对./output/SearchResults.tsv 只选每个nctid只对应一个cancer的drug cancer pair.并根据"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt"判断这个药物是否为cancer drug，
#得非cancer drug  对应的clincal trial drug cancer pairs文件 ./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

system "cat ./output/SearchResults.tsv | cut -f3,5,6 > ./output/cut_SearchResults.tsv"; #因为直接读有问题，所以把需要的列cut处理
my $f1 ="/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
# my $f2 ="./output/SearchResults.tsv";
my $f2 ="./output/cut_SearchResults.tsv";
my $fo1 ="./output/001_extract_drug_cancer_clinical_recruiting_pahse1_early_phase1.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Drug\tCancer\tStatus\n";
my %hash1;
my %hash2;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_claim_primary_name = $f[4];
        $Drug_claim_primary_name =lc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        my $oncotree_main_ID = $f[-2];
        unless($oncotree_main_ID =~/NA/){
            $hash1{$Drug_claim_primary_name}=1;
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Status/){
        my $Status = $f[0];
        my $Conditions = $f[1];
        my $Interventions = $f[2];
        unless($Conditions =~/\|/){ #保证每行的drug只treat一个cancer
            my @Intervention_array = split/\|/;
            foreach my $Drug(@Intervention_array){
                if ($Drug =~/^Drug/){
                    $Drug =~s/Drug://g;
                    $Drug =lc($Drug);
                    $Drug =~ s/"//g;
                    $Drug =~ s/'//g;
                    $Drug =~ s/\s+//g;
                    $Drug =~ s/,//g;
                    $Drug =~s/\&/+/g;
                    $Drug =~s/\)//g;
                    $Drug =~s/\//_/g;
                    unless(exists $hash1{$Drug}){
                        my $output = "$Drug\t$Conditions\t$Status";
                        unless(exists $hash2{$output}){
                            $hash2{$output} =1;
                            print $O1 "$output\n";
                        }
                    }            
                }
            }
        }
        
    }
}

