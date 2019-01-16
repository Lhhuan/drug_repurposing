#用./output/11_prediction_and_icgc_result.txt pandrug 的比较top 和bottom 的drug sensitity,
#得./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.1.txt, ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.2.txt ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.3.txt
#./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.4.txt ./output/15_pandrug_top_buttom_drug_sensitivity_comparison_0.5.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "./output/11_prediction_and_icgc_result.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $inject_command = "wc -l $f1";
my $line = readpipe($inject_command); #system 返回值
my @line_info = split/\s+/,$line;
my $line_number = $line_info[0];
# print STDERR "$line_number\n";

for (my $i=1;$i<6;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
    my $proportion = $i/10;
    my $top_line = $line_number * $proportion;
    $top_line  = sprintf "%.f", $top_line; # 这个是四舍五入取整
    system "head -${top_line} $f1 >./output/15_pandrug_top_${proportion}.txt"; #取top和buttom 的行
    system "tail -${top_line} $f1 >./output/15_pandrug_buttom_${proportion}.txt";
    #---------------------------------------------------------------------------
    my $f2 = "./output/15_pandrug_top_${proportion}.txt";
    open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
    my $fo1 = "./output/15_pandrug_top_${proportion}_final.txt";
    open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
    while(<$I2>)
    {
        chomp;
        my @f= split/\t/;
        if (/^Drug/){
            print $O1 "$_\tclass\tproportion\n";
        }
        else{
            print $O1 "$_\ttop\t${proportion}\n";
        }
    }
    #---------------------------------------------------------------------
    my $f3 = "./output/15_pandrug_buttom_${proportion}.txt";
    open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
    my $fo2 = "./output/15_pandrug_buttom_${proportion}_final.txt";
    open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
    while(<$I3>)
    {
        chomp;
        my @f= split/\t/;
        if (/^Drug/){
            print $O2 "$_\tclass\tproportion\n";
        }
        else{
            print $O2 "$_\tbuttom\t${proportion}\n";
        }
    }
    close($O1);
    close($O2);
    system "cat $fo1 $fo2 >./output/15_pandrug_top_buttom_drug_sensitivity_comparison_${proportion}.txt";

}
