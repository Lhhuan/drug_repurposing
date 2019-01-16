# 用./output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得./output/08_filter_cnv_in_huan.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# my $f1 = "05_cnv_test.txt";
# my $f2 ="huan_cnv_test.txt";
my $f1 = "./output/05_28847918_cnv.txt";
my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/08_filter_cnv_in_huan.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $paper_sample_name = $f[0];
        my $chr = $f[2];
        $chr =~s/chr//g;
        my $start = $f[3];
        my $end= $f[4];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $k1 = $oncotree_detail_ID;
        my $k2 = $oncotree_main_ID;
        my $v = "$paper_sample_name\t$chr\t$start\t$end";
        push @{$hash1{$k1}},$v;
        push @{$hash2{$k2}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $out1 = join("\t",@f[0..10]);
    if(/^#/){
        print $O1 "paper_sample_name\t$out1\toncotree_ID\toncotree_ID_type\n";
    }
    else{
        my $chr= $f[0]; 
        my $start = $f[1];
        my $end = $f[2];
        my $source = $f[9];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $k1 = $oncotree_detail_ID;
        my $k2 = $oncotree_main_ID;
        if ($source =~/cnv_svscore/){
            if (exists $hash1{$k1}){  #首先判断cancer对的上,用$oncotree_detail_ID 判断
                my @infos = @{$hash1{$k1}};
                foreach my $info(@infos){
                    my @f2 = split/\t/,$info;
                    my $paper_sample_name =$f2[0];
                    my $output = "$paper_sample_name\t$out1\t$k1\tdetail";
                    my $chr_p = $f2[1];
                    my $start_p = $f2[2];
                    my $end_p = $f2[3];
                    #------------------------------------开始计算是否paper cnv 是否hit Hotspot，分四种情况
                    #--------------------------------------------
                    if ($chr_p eq $chr){
                        if ($start_p< $start && $start< $end_p){ #---------------------------paper的右边huan的左边overlap
                            print $O1 "$output\n";
                        }
                        elsif($start < $start_p && $start_p< $end ){ #----------------paper的左边huan的z右边overlap
                            print $O1 "$output\n";
                        }
                        else{ 
                            if($start_p<= $start && $end_p >=$end){ #paper 包括huan
                                print $O1 "$output\n";
                            }
                            elsif($start <=$start_p && $end >= $end_p){  #huan包括paper
                                print $O1 "$output\n";
                            } 
                        }
                    }
                }
            }
            else{
                if(exists $hash2{$k2}){ #首先判断cancer对的上,用$oncotree_mian_ID 判断
                    my @infos = @{$hash2{$k2}};
                    foreach my $info(@infos){
                        my @f2 = split/\t/,$info;
                        my $paper_sample_name =$f2[0];
                        my $output = "$paper_sample_name\t$out1\t$k2\tmain";
                        my $chr_p = $f2[1];
                        my $start_p = $f2[2];
                        my $end_p = $f2[3];
                        #------------------------------------开始计算是否paper cnv 是否hit Hotspot，分四种情况
                        #--------------------------------------------
                        if ($chr_p eq $chr){
                            if ($start_p< $start && $start< $end_p){ #---------------------------paper的右边huan的左边overlap
                                print $O1 "$output\n";
                            }
                            elsif($start < $start_p && $start_p< $end ){ #----------------paper的左边huan的z右边overlap
                                print $O1 "$output\n";
                            }
                            else{ 
                                if($start_p<= $start && $end_p >=$end){ #paper 包括huan
                                    print $O1 "$output\n";
                                }
                                elsif($start <=$start_p && $end >= $end_p){  #huan包括paper
                                    print $O1 "$output\n";
                                } 
                            }
                        }
                    }
                }
            }
        }
    }
}

