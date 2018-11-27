#把merge_add_hpo_do_oncotree.txt里的引号替换成空，得merge_add_hpo_do_oncotree_s.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./merge_add_hpo_do_oncotree.txt";
my $fo1 = "./merge_add_hpo_do_oncotree_s.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

#my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\n";
# print $O1 "$title"; 
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $info = $_;
    $info =~s/"//g;
    print $O1 "$info\n";
}

my $f2 ="./refine_new_add_drugbank_indication.txt";
my $fo2 = "./refine_new_add_drugbank_indication_s.txt"; 
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $info = $_;
    $info =~s/"//g;
    print $O2 "$info\n";
}