#把文件分成小文件跑paintor
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


system "less ./paintor/input_loci_list |wc -l > line.txt";
my $f1 ="line.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my $line = $_;
    # print "$line\n";
    my $count_file = $line/100;
     my $count1  = sprintf "%.f",  $count_file; # 这个是四舍五入取整
     my $end_final =$count1*100 +1 ; #不是一百的零头数据
   system "sed -n '$end_final,${line}p' ./paintor/input_loci_list > ./paintor/input_loci_list_final" ;
   system "bash run_paintor_final.sh";
    for (my $i = 0;$i<$count1;$i=$i+1){ #构造参数score_cutoff的数组，
        $i= sprintf("%.f", $i); 
        my $start = $i *100 +1;
        my $end = ($i +1)*100;
        system "sed -n '$start,${end}p' ./paintor/input_loci_list > ./paintor/input_loci_list${i}" ;  #取特定行到特定文件
        my $inputfile = "input_loci_list${i}";
        $ENV{'input'}  = $inputfile;
        system "bash run_paintor_i.sh";
    }
}