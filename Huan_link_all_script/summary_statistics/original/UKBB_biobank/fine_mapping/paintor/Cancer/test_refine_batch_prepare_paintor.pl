#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager;

#my $f1 ="/f/mulinlab/huan/summary_statistics/original/summary_cancer_revise.txt";
my $f1 ="./123.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my %hash1;
my @text = <$I1>;#把文件读进数组
foreach my $line(@text) 
{
    chomp($line);
    my @f= split /\t/,$line;
    my $PMID = $f[6];
    my $Normalized_file = $f[20];
    my $Normalized_sort_file = $Normalized_file;
    $Normalized_sort_file =~s/.txt/_sorted.txt/g;
    my $Folder_name_local = $f[10];
    my $File_ID_local = $f[12];    
    if($Folder_name_local=~/UKBB_biobank/){
        mkdir $PMID;
        my $fi = "/f/mulinlab/huan/summary_statistics/original/UKBB_biobank/huan_ukbb_biobank/$Normalized_file"; #normalized文件
        system "cat $fi | sort -k1,1n -k2,2n > ./$PMID/$Normalized_sort_file"; #对文件进行排序
        $ENV{'input_file'}  = $Normalized_sort_file;
        $ENV{'input_path'} = $PMID ;
        system "bash paintor_finemapping0605_revise_huan_ukbb.sh";
        chdir "./$PMID/";#切换目录
        my $fo1 ="./input_loci_list";

        open my $O1, '>', $fo1 or die "$0 : failed to open input file '$fo1' : $!\n";
        select $O1;
        chdir "./filtered_loci/"; #切换目录
        
        my @files = glob "*.processed";
        foreach my $file(@files){
           print $O1 "$file\n"; 
        }
        close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
        chdir "../";
        mkdir "fine_mapping_output_result";
        system "nohup bash ../run_paintor.sh &"; #准备文件完成，开始运行paintor
        system "rm -r filtered_loci";#中间结果占内存，每次运行出结果就把中间结果删掉
        system "rm -r split_loci"; #中间结果占内存，每次运行出结果就把中间结果删掉


        #print STDERR "$com\n";
        #system "bash run_paintor.sh";
       
        
    }
}

