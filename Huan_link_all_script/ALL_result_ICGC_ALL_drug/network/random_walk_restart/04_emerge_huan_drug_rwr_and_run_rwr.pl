#把./output/../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target作为group走rwr,并把结果存在./output/huan_data_rwr/rwr_result/ 文件夹下面
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
#use Env qw(PATH);
# use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my %hash1;

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        my $drug_target_id = $f[2];
        push @{$hash1{$drugname}},$drug_target_id;
    }
}


foreach my $drug (sort keys %hash1){
    my $fo1 ="./output/huan_data_rwr/start/${drug}.txt"; 
    open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
    my @drug_targets = @{$hash1{$drug}};
    my %hash5;
    @drug_targets = grep { ++$hash5{$_} < 2 } @drug_targets;  #对数组内元素去重
    print $O1 join"\n",@drug_targets;
    close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
        print STDERR "$drug\n";
    #--------------------------------------------------------------------------------------------------------------#开始运行rwr并排序
    system "python run_walker.py ./output/original_network_num.txt ./output/huan_data_rwr/start/${drug}.txt > ./output/huan_data_rwr/rwr_result/${drug}.txt ";
    system "cat ./output/huan_data_rwr/rwr_result/${drug}.txt | sort -k2,2rg >./output/huan_data_rwr/rwr_result/${drug}_sorted.txt";
}
    