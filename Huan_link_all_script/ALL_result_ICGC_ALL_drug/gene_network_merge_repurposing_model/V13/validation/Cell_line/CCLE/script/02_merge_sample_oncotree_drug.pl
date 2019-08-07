#将../output/01_merge_sample_info_oncotree.txt 和../output/011_sample_drug_auc.txt merge 到一起，得../output/02_merge_sample_oncotree_drug.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/01_merge_sample_info_oncotree.txt";
my $f2 ="../output/011_sample_drug_auc.txt";
my $fo1 ="../output/02_merge_sample_oncotree_drug.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);



while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^CCLE_name/){
        my $CCLE_name = $f[0];
        my @cell_name =split/\_/,$CCLE_name;
        my $k = $cell_name[0];
        print STDERR "$k\n";
        #my $k = $CCLE_name;
        my $oncotree_ID = join ("\t",@f[-4..-1]);
        $hash1{$k} =$oncotree_ID;
    }
}

print $O1 "ccl_name\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tcpd_name\tarea_under_curve\texperiment_id\tmaster_cpd_id\tmaster_ccl_id\n";
while(<$I2>)  #snv
{
    chomp;
    my @f= split /\t/;
    unless (/^experiment_id/){
        my $experiment_id = $f[0];
        my $area_under_curve = $f[1];
        my $master_cpd_id =$f[2];
        my $master_ccl_id = $f[3];
        my $cpd_name = $f[4];
        my $ccl_name = $f[5];    
        my $k = $ccl_name;
        if (exists $hash1{$k}){
            my $oncotree_ID = $hash1{$k};
            my $output = "$k\t$oncotree_ID\t$cpd_name\t$area_under_curve\t$experiment_id\t$master_cpd_id\t$master_ccl_id";
            print $O1 "$output\n";
        }
    }
}





close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
