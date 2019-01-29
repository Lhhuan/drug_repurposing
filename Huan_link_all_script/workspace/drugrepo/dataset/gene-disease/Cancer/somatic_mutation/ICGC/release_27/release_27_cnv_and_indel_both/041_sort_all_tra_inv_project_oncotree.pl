#把./pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt中的chr1,start1,end1, chr2,start2,end2进行排序，让小的在前面，
#得./pathogenic_hotspot/04_sorted_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="huan_cnv_test.txt";
# my $f2 = "05_cnv_test.txt";
# my $fo1 = "./output/08_filter_cnv_in_huan1.txt";

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/pathogenic_hotspot/04_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";
my $fo1 = "./pathogenic_hotspot/04_sorted_all_tra_inv_pathogenic_hotspot_gene_oncotree.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);



my $header = "#CHROM1\tBEGIN1\tEND1\tENSG1\tCHROM2\tBEGIN2\tEND2\tENSG2\tPROJECT\tSVSCORETOP10\tSVSCOREMAX\tSVSCORESUM\tSVSCOREMEAN\tsource\tID\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue";
print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^#/){
        my $chr1= $f[0]; 
        my $start1 = $f[1];
        my $end1 = $f[2];
        my $ENSG1 = $f[3];
        my $chr2= $f[4]; 
        my $start2 = $f[5];
        my $end2 = $f[6];
        my $ENSG2 = $f[7];
        my $project = $f[8];
        my $SVSCORETOP10 = $f[9];
        my $SVSCOREMAX =$f[10];
        my $SVSCORESUM =$f[11];
        my $SVSCOREMEAN =$f[12];
        my $source =$f[13];
        my $ID = $f[14];
        my $oncotree_detail_term= $f[-4];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_term = $f[-2];
        my $oncotree_main_ID = $f[-1];
        my $out1 = "$chr1\t$start1\t$end1\t$ENSG1";
        my $out2 = "$chr2\t$start2\t$end2\t$ENSG2";
        my $out3 = join("\t",@f[8..18]);
        if ($chr1 !~/X|Y/i && $chr2!~ /X|Y/i){ #避免ASCII带来的麻烦，将X和Y 染色体分开判断
            if ($chr1 < $chr2){ #chr1<chr2, 按照源文件输出 等于输出"$out1\t$out2\t$out3\n"
                print $O1 "$_\n";
            }
            elsif($chr1 > $chr2){#chr1>chr2, 把out2放在前面输出
                my $output = "$out2\t$out1\t$out3";
                print $O1 "$output\n";
            }
            else{ #chr1 == chr2时，判断start,start 小的在前面输出
                if($start1<$start2){  #start1<start2, 按照源文件输出 等于输出"$out1\t$out2\t$out3\n"
                    print $O1 "$_\n";
                }
                elsif($start1 >$start2){#start1<start2, 把out2放在前面输出
                    my $output = "$out2\t$out1\t$out3";
                    print $O1 "$output\n";
                }
                else{
                    print STDERR "$_\n";
                }
            }
        }
        else{
            if ($chr1 lt $chr2){ #chr1<chr2, 按照源文件输出 等于输出"$out1\t$out2\t$out3\n"
                print $O1 "$_\n";
            }
            elsif($chr1 gt $chr2){#chr1>chr2, 把out2放在前面输出
                my $output = "$out2\t$out1\t$out3";
                print $O1 "$output\n";
            }
            else{ #chr1 == chr2时，判断start,start 小的在前面输出
                if($start1<$start2){  #start1<start2, 按照源文件输出 等于输出"$out1\t$out2\t$out3\n"
                    print $O1 "$_\n";
                }
                elsif($start1 >$start2){#start1<start2, 把out2放在前面输出
                    my $output = "$out2\t$out1\t$out3";
                    print $O1 "$output\n";
                }
                else{
                    print STDERR "$_\n";
                }
            }    
        }
    }
}

