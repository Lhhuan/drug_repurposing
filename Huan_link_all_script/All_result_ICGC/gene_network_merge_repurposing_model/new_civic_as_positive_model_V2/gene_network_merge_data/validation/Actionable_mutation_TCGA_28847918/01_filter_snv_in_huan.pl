#用../TCGA_28847918/output/06_filter_snv_in_icgc.txt和../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt 取overlap得./output/01_filter_snv_in_huan.txt
#uniq 得./output/01_sorted_filter_snv_in_huan.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../../huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt";
my $f2 = "../TCGA_28847918/output/06_filter_snv_in_icgc.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/01_filter_snv_in_huan.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $output1 = join("\t",@f[0..12],@f[15,16],@f[18,19]);
    if(/^Drug_chembl_id/){
        print $O1 "oncotree_ID\tMutation_id\t$output1\toncotree_ID_type\tpaper_sample_name\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0]; 
        my $Mutation_id = $f[8];
        my $oncotree_detail_ID = $f[13];
        my $oncotree_main_ID = $f[14];
        my $k1 = "$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$oncotree_main_ID\t$Mutation_id";
        push @{$hash1{$k1}},$output1;
        push @{$hash2{$k2}},$output1;
    }
}


while(<$I2>)
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
        my $k1 = "$oncotree_detail_ID\t$Mutation_id";
        my $k2 = "$oncotree_main_ID\t$Mutation_id";
        my $info = "$paper_sample_name";
        if (exists $hash1{$k1}){
            my @output1s = @{$hash1{$k1}};
            foreach my $output1(@output1s){
                my $output2 = "$k1\t$output1\tdetail\t$info";
                # unless(exists $hash3{$output2}){
                #     $hash3{$output2}=1;
                    print $O1 "$output2\n";
                # }
            }
        }
        else{
            if (exists $hash2{$k2}){
                my @output1s = @{$hash2{$k2}};
                foreach my $output1(@output1s){
                    my $output2 = "$k2\t$output1\tmain\t$info";
                    # unless(exists $hash3{$output2}){
                        # $hash3{$output2}=1;
                        print $O1 "$output2\n";
                    # }
                }
            }
        }
    }
}

close ($O1);
system "sort ./output/01_filter_snv_in_huan.txt | uniq >./output/01_sorted_filter_snv_in_huan.txt" ; #暂时注释