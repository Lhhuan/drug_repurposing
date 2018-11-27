#把huan_mapin.txt和huan_map_oncotree.txt merge到一个文件，得文件huan_mapin_do_hpo_oncotree.txt，也就是huan_mapin_do_hpo_oncotree.txt包含map到do ,hpo, oncotree的信息
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_mapin.txt";
my $f2 ="./huan_map_oncotree.txt";
my $fo1 = "./huan_mapin_do_hpo_oncotree.txt"; #mapin do ,hpo，oncotree的所有数据。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\tOncoTree_term\tOncoTree_IDs\n";
select $O1;
print "$title"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $Indication_ID = $f[0];
         my $Indication = $f[1];
        my $v = join("\t",@f[1..5]);
        $hash1{$Indication_ID} = $v;
     }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $Indication_ID = $f[0];
         my $Indication = $f[1];
         my $k = "$Indication_ID\t$Indication";
         my $v = join("\t",@f[2,3]);
         $hash2{$Indication_ID} = $v;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my $v = $hash1{$ID};
        print $O1 "$ID\t$v\t$s\n";
    } 
}





