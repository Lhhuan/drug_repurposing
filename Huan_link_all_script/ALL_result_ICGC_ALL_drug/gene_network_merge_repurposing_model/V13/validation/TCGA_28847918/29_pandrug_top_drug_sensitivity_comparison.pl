#将drug的predict value 分成top 0_0.3, 0.3_1共2组做比较,分别得文件./output/29_pandrug_top_${top}_${buttom}.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "./output/11_prediction_and_icgc_result.txt";


my $inject_command = "wc -l $f1";
my $line = readpipe($inject_command); #system 返回值
my @line_info = split/\s+/,$line;
my $line_number = $line_info[0];


my @pro = (0, 0.3, 1);

for (my $i=1;$i<3;$i++){  #此时进行赋值
    my $top_line = $pro[$i-1] * $line_number;
    my $buttom_line = $pro[$i] * $line_number;
    $top_line  = sprintf "%.f", $top_line; # 这个是四舍五入取整
    $buttom_line = sprintf "%.f", $buttom_line;# 这个是四舍五入取整
    my $true_top_line =$top_line +1;
    my $top = $pro[$i-1];
    my $buttom = $pro[$i];
    my $proportion ="${top}_${buttom}";
    # system " head -1 $f1 >./output/15_pandrug_top_${proportion}.txt";
    system "sed -n '$true_top_line,${buttom_line}p' $f1 >./output/29_pandrug_top_${proportion}.txt";
    #---------------------------------------------------------------------------
    my $f2 = "./output/29_pandrug_top_${proportion}.txt";
    open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
    my $fo1 = "./output/29_pandrug_top_${proportion}_final.txt";
    open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

    my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\tvalue_in_paper";
    if ($i>1){
        print $O1 "$header\tproportion\n";
    }
    while(<$I2>)
    {
        chomp;
        my @f= split/\t/;
        if (/^Drug/){
            print $O1 "$_\tproportion\n";
        }
        else{
            print $O1 "$_\t${proportion}\n";
        }
    }
    close ($I2);
    close ($O1);
    #---------------------------------------------------------------------
}


