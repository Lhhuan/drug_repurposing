#因为./output/04_new_indication.txt中indication 较多，有5615个，map 到hpo和do浪费时间较多，但此map并无意义，所以此处用unmap代替。得文件./output/05_new_indication_do_hpo_unmap.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/04_new_indication.txt";
my $fo1 ="./output/05_new_indication_do_hpo_unmap.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
print $O1 "Drug_indication|Indication_class\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\n";


while(<$I1>)
{
    chomp;
    my @f = split/\t/;
    unless(/^Drug_indication/){
        my $drug_indication = $f[0];#是Drug_indication|Indication_class
        print $O1 "$drug_indication\tUnmap\tUnmap\tUnmap\tUnmap\n";
    }
}

