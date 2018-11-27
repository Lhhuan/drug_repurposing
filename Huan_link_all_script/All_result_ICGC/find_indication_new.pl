#找出在DGIdb_all_target_drug_indication.txt中存在，但在huan_used_mapin.txt中不存在的indication,（也就是新增的indication）,得new_add_drugbank_indication.txt,得huan_used_mapin.txt 把引号去掉，全部转变成小写后的结果refine_huan_used_mapin.txt，
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./DGIdb_all_target_drug_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
#my $f2 ="./DGIdb_used_mapin.txt";
my $f2 ="./huan_used_mapin.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./new_add_drugbank_indication.txt"; #新增加的indication
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./dgidb_unique_indication.txt"; #DGIdb_all_target_drug_indication.txt的 unique indication 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./refine_huan_used_mapin.txt"; ##huan_used_mapin.txt 把引号去掉，全部转变成小写后的结果
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $indication = $f[-1];
        $indication =~s/"//g;
        $indication=lc($indication);
        $indication =~s/^\s+//g;
         $hash1{$indication}=1;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $indication = $f[1];
         $indication =~s/"//g;
         $indication=lc($indication);
         $indication =~s/^\s+//g;
         $hash2{$indication}=1;
         unless(exists $hash3{$indication}){
             $hash3{$indication} =1;
             print $O3 "$indication\n";
         }
     }
}

foreach my $indication (sort keys %hash1){
    print $O2 "$indication\n";
    unless(exists $hash2{$indication}){
        print $O1 "$indication\n";
    }
}