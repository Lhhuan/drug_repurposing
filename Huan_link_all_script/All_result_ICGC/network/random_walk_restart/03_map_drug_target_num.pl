##把../../refined_huan_target_drug_indication_final_symbol.txt 的每个drug的所有target(entrez_id)都转换成在网络中的编号，得文件03_huan_drug_target_num.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../refined_huan_target_drug_indication_final_symbol.txt";#输入的是drug target
my $f2 ="../network_gene_num.txt";
my $fo1 ="./03_huan_drug_target_num.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug\tdrug_entrez\trepo_entrez_network_id\n"; 


my(%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $drug_name = $f[0];
         $drug_name =~s/\s+/_/g;#为了建文件夹方便，把空格替换成_
         $drug_name =~s/"//g;#后面也是为了建文件夹方便
         $drug_name =~s/\(//g;
         $drug_name =~s/\)//g;
         $drug_name =~s/\//_/g;
         $drug_name =~s/\&/+/g; #把&替换+
         $drug_name =~s/-/_/g;
         my $drug_symbol = $f[1];
         my $drug_entrez = $f[2];
         unless($drug_entrez=~/NULL|NA/){
             push @{$hash1{$drug_name}},$drug_entrez;
         }
     }
}
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrez = $f[1];
         my $id = $f[2];
         $hash2{$entrez} = $id;
     }
}
my $fo2 ="./drug_list.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


#对第一列(drug_entrez)基因进行id的转换
foreach my $drug (sort keys %hash1){
    print $O2 "$drug\n";
     my @drug_entrezs =@{$hash1{$drug}};
      my %hash3;
    @drug_entrezs = grep { ++$hash3{$_} < 2 }  @drug_entrezs;  #对数组内元素去重
    foreach my $entrez(@drug_entrezs){ 
        if (exists $hash2{$entrez}){ #drug target和
        my $id = $hash2{$entrez}; #在网络中的序号
        print $O1 "$drug\t$entrez\t$id\n";
        }
    }
}

   


