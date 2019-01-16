# 用./output/05_28847918_cnv.txt和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得./output/08_filter_cnv_in_huan.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="huan_cnv_test.txt";
# my $f2 = "05_cnv_test.txt";
# my $fo1 = "./output/08_filter_cnv_in_huan1.txt";

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_CNV_dup_del_pathogenic_hotspot_gene_oncotree.txt";
my $f2 = "./output/05_28847918_cnv.txt";
my $fo1 = "./output/08_filter_cnv_in_huan.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


my $header = "paper_sample_name\t#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\toncotree_ID\toncotree_ID_type";
print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    my $out1 = join("\t",@f[0..10]);
    unless(/^#/){
        my $chr= $f[0]; 
        my $start = $f[1];
        my $end = $f[2];
        my $source = $f[9];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $k1 = $oncotree_detail_ID;
        my $k2 = $oncotree_main_ID;
        # my $v = "$source\t$chr\t$start\t$end";
        push @{$hash1{$k1}},$out1;
        push @{$hash2{$k2}},$out1;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $paper_sample_name = $f[0];
        my $chr_p = $f[2];
        $chr_p =~s/chr//g;
        my $start_p = $f[3];
        my $end_p= $f[4];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $k1 = $oncotree_detail_ID;
        my $k2 = $oncotree_main_ID;
        # my $v = "$paper_sample_name\t$chr\t$start\t$end";
        if (exists $hash1{$k1}){  #首先判断cancer对的上,用$oncotree_detail_ID 判断
            my @infos = @{$hash1{$k1}};
            foreach my $info(@infos){
                my @f2 = split/\t/,$info;
                my $output = "$paper_sample_name\t$info\t$k1\tdetail";
                my $source =$f2[9];
                if($source =~/cnv_svscore/){
                    my $chr = $f2[0];
                    my $start = $f2[1];
                    my $end = $f2[2];
                    #------------------------------------开始计算是否paper cnv 是否hit Hotspot，分四种情况
                    #--------------------------------------------
                    if ($chr_p eq $chr){
                        if ($start_p< $start && $start<= $end_p){ #---------------------------paper的右边huan的左边overlap
                            print $O1 "$output\n";
                        }
                        elsif($start < $start_p && $start_p<= $end ){ #----------------paper的左边huan的z右边overlap
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
        else{
            if(exists $hash2{$k2}){ #首先判断cancer对的上,用$oncotree_mian_ID 判断
                my @infos = @{$hash2{$k2}};
                foreach my $info(@infos){
                    my @f2 = split/\t/,$info;
                    my $output = "$paper_sample_name\t$info\t$k2\tmain";
                    my $source =$f2[9];
                    my $chr = $f2[0];
                    my $start = $f2[1];
                    my $end = $f2[2];
                    if($source =~/cnv_svscore/){
                        #------------------------------------开始计算是否paper cnv 是否hit Hotspot，分四种情况
                        #--------------------------------------------
                        if ($chr_p eq $chr){
                            if ($start_p< $start && $start<= $end_p){ #---------------------------paper的右边huan的左边overlap
                                print $O1 "$output\n";
                            }
                            elsif($start < $start_p && $start_p<= $end ){ #----------------paper的左边huan的z右边overlap
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
