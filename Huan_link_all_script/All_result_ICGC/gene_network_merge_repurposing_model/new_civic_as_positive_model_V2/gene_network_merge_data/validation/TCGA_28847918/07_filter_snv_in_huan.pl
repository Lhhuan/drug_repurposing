#用./output/06_filter_snv_in_icgc.txt和../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得./output/07_filter_snv_in_huan.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/06_filter_snv_in_icgc.txt";
my $f2 = "../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/07_filter_snv_in_huan.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug= $f[1];
        my $paper_sample_name = $f[2];
        my $oncotree_detail_ID = $f[-4];
        my $oncotree_main_ID = $f[-2];
        my $Mutation_id = $f[-1];
        my $k1 = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_main_ID\t$Mutation_id";
        my $v = "$Drug\t$paper_sample_name";
        push @{$hash1{$k1}},$v;
        push @{$hash2{$k2}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $output1 = join("\t",@f[1..12],@f[15,16],@f[18,19]);
    if(/^Drug_chembl_id/){
        print $O1 "Drug_chembl_id_Drug_claim_primary_name\toncotree_ID\tMutation_id\t$output1\toncotree_ID_type\tDrug_in_paper\tpaper_sample_name\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0]; 
        my $Mutation_id = $f[8];
        my $oncotree_detail_ID = $f[13];
        my $oncotree_main_ID = $f[14];
        my $k1 = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_main_ID\t$Mutation_id";
        if (exists $hash1{$k1}){
            my @infos = @{$hash1{$k1}};
            foreach my $info(@infos){
                my $output2 = "$k1\t$output1\tdetail\t$info";
                unless(exists $hash3{$output2}){
                    $hash3{$output2}=1;
                    print $O1 "$output2\n";
                }
            }
        }
        else{
            if (exists $hash2{$k2}){
            my @infos = @{$hash2{$k2}};
                foreach my $info(@infos){
                    my $output2 = "$k2\t$output1\tmain\t$info";
                    unless(exists $hash3{$output2}){
                        $hash3{$output2}=1;
                        print $O1 "$output2\n";
                    }
                }                
            }
        }
    }
}

