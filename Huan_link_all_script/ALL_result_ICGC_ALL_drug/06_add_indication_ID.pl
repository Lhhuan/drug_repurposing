#为./output/all_indication_do_hpo_oncotree.txt中的indication编号，得./output/all_id_indication_do_hpo_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/all_indication_do_hpo_oncotree.txt";
my $fo1 = "./output/all_id_indication_do_hpo_oncotree.txt"; #mapin do ,hpo，oncotree的所有数据。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\n";
select $O1;
print "$title"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Indication_ID|Drug_indication/){
        print "$.\t$_\n";
    }
}
