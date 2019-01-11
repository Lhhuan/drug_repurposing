#将所有project (./data/download_TCGA_from_UCSC_xena/${project}/)下CNV和SNV合在一起，得./output/02_all_project_cnv.txt，./output/02_all_project_snv.txt，得到hit住的project 得文件./output/02_hit_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./data/Project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/02_all_project_snv.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/02_all_project_cnv.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "sample\tchr\tstart\tend\treference\talt\tgene\teffect\tDNA_VAF\tRNA_VAF\tAmino_Acid_Change\tproject\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";
print $O2 "sample\tchr\tstart\tend\tvalue\tproject\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\n";


while(<$I1>)
{
    chomp;
    unless(/^project/){
        my @f= split/\t/;
        my $project = $f[0];
        my $k =join("\t",@f[1..4]);
        my $f2 = "./data/download_TCGA_from_UCSC_xena/${project}/snv/*.gz";
        open(my $I2,"gzip -dc $f2|") or die ("can not open $f2\n");
        while(<$I2>){
            chomp;
            unless(/^sample/){
                print $O1 "$_\t$project\t$k\n";
            }
        }
        my $f3 = "./data/download_TCGA_from_UCSC_xena/${project}/cnv/*.gz";
        open(my $I3,"gzip -dc $f3|") or die ("can not open $f3\n");
        while(<$I3>){
            chomp;
            unless(/^sample/){
                print $O2 "$_\t$project\t$k\n";
            }
        }
    }

}

close($O1);
close($O2);