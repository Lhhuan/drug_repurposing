#用refine_huan_used_mapin.txt到huan_used_mapin.txt中提取unique的indication ID及indication，得refine_huan_used_mapin_id.txt,由于字符问题不能匹配的indication character_error_indication.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./refine_huan_used_mapin.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
#my $f2 ="./DGIdb_used_mapin.txt";
my $f2 ="./huan_used_mapin.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./refine_huan_used_mapin_id.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./character_error_indication.txt"; #由于字符问题不能匹配的indication
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
print $O1 "Indication_ID\tIndication\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $indication = $f[-1];
    $indication =~s/"//g;
    $indication=lc($indication);
    $indication =~s/^\s+//g;
    $hash1{$indication}=1;
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $ID = $f[0];
         my $indication = $f[1];
         $indication =~s/"//g;
         $indication=lc($indication);
         $indication =~s/^\s+//g;
         $hash2{$indication}=$ID;

     }
}

foreach my $indication (sort keys %hash1){
    if(exists $hash2{$indication}){
        my $ID = $hash2{$indication};
        print $O1 "$ID\t$indication\n";
    }
    else{
        print $O1 "NA\t$indication\n";
        print $O2 "$indication\n";
    }
}