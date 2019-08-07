#用../output/sorted_tra_sample.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_sorted_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt"
#做overlap,得../output/07_tra_in_huan.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="huan_cnv_test.txt";
# my $f2 = "05_cnv_test.txt";
# my $fo1 = "./output/08_filter_cnv_in_huan1.txt";

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_sorted_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";
my $f2 = "../output/sorted_tra_sample.txt";
# my $f2 = "test_tra.txt";
my $fo1 = "../output/07_tra_in_huan.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);



#my $header = "sample_name\t#CHROM\tBEGIN\tEND\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tSVTYPE\tsource\tID\toncotree_ID\toncotree_ID_type";
my $header = "sample_name\tchr1\tstart1\tend1\tchr2\tstart2\tend2\tproject\tSVSCORETOP10\tsource\tID\toncotree_ID\toncotree_ID_type";
print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^#/){
        my $chr1= $f[0]; 
        my $start1 = $f[1];
        my $end1 = $f[2];
        my $chr2= $f[4]; 
        my $start2 = $f[5];
        my $end2 = $f[6];
        my $project = $f[8];
        my $SVSCORETOP10 = $f[9];
        my $source =$f[13];
        my $ID = $f[14];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $k1 = $oncotree_detail_ID;
        my $k2 = $oncotree_main_ID;
        my $out1 = "$chr1\t$start1\t$end1\t$chr2\t$start2\t$end2\t$project\t$SVSCORETOP10\t$source\t$ID";
        # my $v = "$source\t$chr\t$start\t$end";
        if($source =~/tra/){
            push @{$hash1{$k1}},$out1;
            push @{$hash2{$k2}},$out1;
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^CCLE_name/){
        my $paper_sample_name = $f[0];
        my $chr_p1 = $f[1];
        $chr_p1 =~s/chr//g;
        my $start_p1 = $f[2];
        my $end_p1= $f[3];
        my $chr_p2 = $f[4];
        $chr_p2 =~s/chr//g;
        my $start_p2 = $f[5];
        my $end_p2= $f[6];       
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
                my $source =$f2[8];
                if($source =~/tra_svscore/){
                    my $chr1 = $f2[0];
                    my $start1 = $f2[1];
                    my $end1 = $f2[2];
                    my $chr2 = $f2[3];
                    my $start2 = $f2[4];
                    my $end2 = $f2[5];
                    #------------------------------------开始计算是否paper inv 是否hit Hotspot，分四种情况
                    #--------------------------------------------
                    if ($chr_p1 eq $chr1){
                        if ($chr_p2 eq $chr2 ){
                            if ($start_p1< $start1 && $start1<= $end_p1){ #---------------------------paper1的右边huan1的左边overlap
                                #-----------------------------------------------------------------------paper2和huan2
                                if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                    print $O1 "$output\n";
                                }
                                elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                    print $O1 "$output\n";
                                }
                                else{ 
                                    if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                        print $O1 "$output\n";
                                    } 
                                }
                            }
                            elsif($start1 < $start_p1 && $start_p1<= $end1 ){ #----------------paper1的左边huan1的右边overlap
                            #-------------------------------------------------------------------paper2和huan2
                                if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                    print $O1 "$output\n";
                                }
                                elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                    print $O1 "$output\n";
                                }
                                else{ 
                                    if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                        print $O1 "$output\n";
                                    } 
                                }
                            }
                            else{ 
                                if($start_p1<= $start1 && $end_p1 >=$end1){ #paper1 包括huan1
                                #-------------------------------------------------------------------------paper2和huan2
                                    if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                        print $O1 "$output\n";
                                    }
                                    else{ 
                                        if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                            print $O1 "$output\n";
                                        } 
                                    }
                                }
                                elsif($start1 <=$start_p1 && $end1 >= $end_p1){  #huan1包括paper1
                                #------------------------------------------------------------paper2和huan2 
                                    if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                        print $O1 "$output\n";
                                    }
                                    else{ 
                                        if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
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
        else{
            if(exists $hash2{$k2}){ #首先判断cancer对的上,用$oncotree_mian_ID 判断
                my @infos = @{$hash2{$k2}};
                foreach my $info(@infos){
                    my @f2 = split/\t/,$info;
                    my $output = "$paper_sample_name\t$info\t$k2\tmain";
                    my $source =$f2[8];
                    if($source =~/tra_svscore/){
                        my $chr1 = $f2[0];
                        my $start1 = $f2[1];
                        my $end1 = $f2[2];
                        my $chr2 = $f2[3];
                        my $start2 = $f2[4];
                        my $end2 = $f2[5];
                        #------------------------------------开始计算是否paper inv 是否hit Hotspot，分四种情况
                        #--------------------------------------------
                        if ($chr_p1 eq $chr1){
                            if ($chr_p2 eq $chr2 ){
                                if ($start_p1< $start1 && $start1<= $end_p1){ #---------------------------paper1的右边huan1的左边overlap
                                    #-----------------------------------------------------------------------paper2和huan2
                                    if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                        print $O1 "$output\n";
                                    }
                                    else{ 
                                        if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                            print $O1 "$output\n";
                                        } 
                                    }
                                }
                                elsif($start1 < $start_p1 && $start_p1<= $end1 ){ #----------------paper1的左边huan1的右边overlap
                                #-------------------------------------------------------------------paper2和huan2
                                    if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                        print $O1 "$output\n";
                                    }
                                    elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                        print $O1 "$output\n";
                                    }
                                    else{ 
                                        if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                            print $O1 "$output\n";
                                        } 
                                    }
                                }
                                else{ 
                                    if($start_p1<= $start1 && $end_p1 >=$end1){ #paper1 包括huan1
                                    #-------------------------------------------------------------------------paper2和huan2
                                        if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                            print $O1 "$output\n";
                                        }
                                        else{ 
                                            if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                                print $O1 "$output\n";
                                            }
                                            elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
                                                print $O1 "$output\n";
                                            } 
                                        }
                                    }
                                    elsif($start1 <=$start_p1 && $end1 >= $end_p1){  #huan1包括paper1
                                    #------------------------------------------------------------paper2和huan2 
                                        if ($start_p2< $start2 && $start2<= $end_p2){ #---------------------------paper的右边huan的左边overlap
                                            print $O1 "$output\n";
                                        }
                                        elsif($start2 < $start_p2 && $start_p2<= $end2 ){ #----------------paper的左边huan的z右边overlap
                                            print $O1 "$output\n";
                                        }
                                        else{ 
                                            if($start_p2<= $start2 && $end_p2 >=$end2){ #paper 包括huan
                                                print $O1 "$output\n";
                                            }
                                            elsif($start2 <=$start_p2 && $end2 >= $end_p2){  #huan包括paper
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
        }
    }
}
