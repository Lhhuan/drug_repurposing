#寻找actionable mutation中的pathogenicity_mutation，寻找在./output/01_ICGC_mutation_id_HGVSg.txt中出现的."/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/actionable_mutation/actionable_hit_all_ICGC_mutation/output/03_actionable_mutation_transvar_ref_alt.txt"
#得./output/04_actionable_mutaton_in_pathogenicity.txt 得所有的actionable mutation文件./output/04_all_actionable_mutation.txt，得可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_transform_hgvs.txt 
#得不可以转成hgvs的actionable_mutation文件./output/04_actionable_mutation_can_not_transform_hgvs.txt 

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/01_ICGC_mutation_id_HGVSg.txt";
my $f2 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/actionable_mutation/actionable_hit_all_ICGC_mutation/output/03_actionable_mutation_transvar_ref_alt.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/04_all_actionable_mutation.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/04_actionable_mutation_can_not_transform_hgvs.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 = "./output/04_actionable_mutation_can_transform_hgvs.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my $fo4 = "./output/04_actionable_mutaton_in_pathogenicity.txt";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my $fo5 = "./output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "variant_id\tfinal_variant\thgvsg";
print  $O1 "$header\n";
print  $O2 "$header\n";
print  $O3 "$header\n";
print  $O4 "$header\tICGC_Mutation_ID\n";
print  $O5 "$header\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        my $HGVSg = $f[1];
        push @{$hash1{$HGVSg}},$Mutation_ID;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^oncotree_term_detail/){
        my $chr = $f[11];
        my $start = $f[12];
        my $end = $f[13];
        my $ref = $f[14];
        my $alt = $f[15];
        my $variant_id = "$chr\,$start\,$end\,$ref\,$alt";
        my $hgvsg = $f[-2];
        $hgvsg =~s/chr//g;
        $hgvsg =~ s/^\.$/NA/g; #把只是.的替换为NA
        $hgvsg =~s/del.*ins/delins/g; #把7:g.140453136_140453137delACinsTT 替换为7:g.140453136_140453137delinsTT
        my $final_variant = $f[-3];
        my $v = "$variant_id\t$final_variant";
        my $output  = "$v\t$hgvsg";
        unless (exists $hash2{$output}){ #all actionable mutation
            $hash2{$output} =1;
            print $O1 "$output\n";
        }
        if($hgvsg =~/\bNA\b/){
            unless (exists $hash3{$output}){ #不可以转成hgvs的actionable_mutation文件
                $hash3{$output} =1;
                print $O2 "$output\n";
            }
        }
        else{
            unless (exists $hash4{$output}){ #可以转成hgvs的actionable_mutation文件
                $hash4{$output} =1;
                print $O3 "$output\n";
            }
            if(exists $hash1{$hgvsg}){
                my @mutation_ids = @{$hash1{$hgvsg}};
                foreach my $mutation_id(@mutation_ids){
                    my $output2 = "$output\t$mutation_id";
                    unless (exists $hash5{$output2}){ #actionable_mutaton_in_pathogenicity
                        $hash5{$output2} =1;
                        print $O4 "$output2\n";
                    }
                }
            }
            else{
                unless (exists $hash6{$output}){ #可以转成hgvs的actionable_mutation,但不在icgc的目标文件中文件
                    $hash6{$output} =1;
                    print $O5 "$output\n";
                }
            }

        }
    }
}

system "cat ./output/04_actionable_mutation_can_not_transform_hgvs.txt | cut -f2 | sort -u > ./output/unique_04_actionable_mutation_can_not_transform_hgvs.txt";
system "cat ./output/04_actionable_mutation_can_transform_hgvs.txt | cut -f3 | sort -u > ./output/unique_04_actionable_mutation_can_transform_hgvs.txt";
system "cat ./output/04_actionable_mutaton_in_pathogenicity.txt | cut -f3 | sort -u > ./output/unique_04_actionable_mutaton_in_pathogenicity.txt";
system "cat ./output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt | sort -u > ./output/unique_04_can_transform_actionable_mutaton_not_in_pathogenicity.txt";

