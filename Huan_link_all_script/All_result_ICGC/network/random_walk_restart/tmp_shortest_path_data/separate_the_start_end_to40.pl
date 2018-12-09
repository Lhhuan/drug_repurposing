#把文件分成小文件跑最短路径
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


system "less ../08_uni_start_end_shortest.txt |wc -l > line.txt";
my $f1 ="line.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my $line = $_;
    # print "$line\n";
    my $count_file_line = $line/40; #每个文件的行数。
     my $count_line1 = sprintf "%.f",  $count_file_line; # 对行数四舍五入取整
     my $end_final =$count_line1*39 +1 ; #取最后一个文件的行数。
     print STDERR "$end_final\n";
   system "sed -n '$end_final,${line}p' ../08_uni_start_end_shortest.txt > ./08_uni_start_end_shortest40.txt" ;
    for (my $i = 1;$i<40;$i=$i+1){ #进行39个循环
        $i= sprintf("%.f", $i); 
        my $start = ($i-1) *$count_line1 +1;
        my $end = $i*$count_line1;
        system "sed -n '$start,${end}p' ../08_uni_start_end_shortest.txt > ./08_uni_start_end_shortest${i}.txt" ;  #取特定行到特定文件
    }
}

