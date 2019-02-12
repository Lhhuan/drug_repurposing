#对../output/tra_sample.txt 中的chr1,start1,end1, chr2,start2,end2进行排序，让小的在前面，得../output/sorted_tra_sample.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../output/tra_sample.txt";
my $fo1 = "../output/sorted_tra_sample.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "CCLE_name\tchr1\tstart1\tend1\tchr2\tstart2\tend2\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^CCLE_name/){
        my $CCLE_name = $f[0];
        my $chr1= $f[1]; 
        $chr1 =~s/chr//g;
        my $start1 = $f[2];
        my $end1 = $f[3];
        my $chr2= $f[4]; 
        $chr2 =~s/chr//g;
        my $start2 = $f[5];
        my $end2 = $f[6];
        my $oncotree_detail_term= $f[7];
        my $oncotree_detail_ID = $f[8];
        my $oncotree_main_term = $f[9];
        my $oncotree_main_ID = $f[10];
        my $out1 = "$chr1\t$start1\t$end1";
        my $out2 = "$chr2\t$start2\t$end2";
        my $out3 = join("\t",@f[7..10]);
        unless($chr1 =~/GL|MT/ || $chr2 =~/GL|MT/){  #去掉杂乱的染色体
            if ($chr1 !~/X|Y/i && $chr2!~ /X|Y/i){ #避免ASCII带来的麻烦，将X和Y 染色体分开判断
                if ($chr1 < $chr2){ #chr1<chr2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                    print $O1 "$_\n";
                }
                elsif($chr1 > $chr2){#chr1>chr2, 把out2放在前面输出
                    my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                    print $O1 "$output\n";
                }
                else{ #chr1 == chr2时，判断start,start 小的在前面输出
                    if($start1<$start2){  #start1<start2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                        print $O1 "$_\n";
                    }
                    elsif($start1 >$start2){#start1<start2, 把out2放在前面输出
                        my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                        print $O1 "$output\n";
                    }
                    else{  #start1= start2,判断 $end1 和$end2
                    if($end1<$end2){  #$end1<$end2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                        print $O1 "$_\n";
                        } 
                        elsif($end1>$end2){
                            my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                            print $O1 "$output\n";
                        }
                        else{ #chr1= chr2, start1 == start2, end1 == end2,这样的位点可以不要
                            print STDERR "$_\n";
                        }
                    }
                }
            }
            else{
                if ($chr1 lt $chr2){ #chr1<chr2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                    print $O1 "$_\n";
                }
                elsif($chr1 gt $chr2){#chr1>chr2, 把out2放在前面输出
                    my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                    print $O1 "$output\n";
                }
                else{ #chr1 == chr2时，判断start,start 小的在前面输出
                    if($start1<$start2){  #start1<start2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                        print $O1 "$_\n";
                    }
                    elsif($start1 >$start2){#start1<start2, 把out2放在前面输出
                        my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                        print $O1 "$output\n";
                    }
                    else{  #start1= start2,判断 $end1 和$end2
                    if($end1<$end2){  #$end1<$end2, 按照源文件输出 等于输出"$CCLE_name\t$out1\t$out2\t$out3\n"
                        print $O1 "$_\n";
                        } 
                        elsif($end1>$end2){
                            my $output = "$CCLE_name\t$out2\t$out1\t$out3";
                            print $O1 "$output\n";
                        }
                        else{ #chr1= chr2, start1 == start2, end1 == end2,这样的位点可以不要
                            print STDERR "$_\n";
                        }
                    }
                } 
            }
        }
    }
}

