
#将mapin do ,hpo的所有数据写在一个文件里。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_mapin_do.txt";
my $f2 ="./huan_mapin_hpo.txt";
my $fo1 = "./huan_mapin.txt"; #mapin do ,hpo的所有数据。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\n";
select $O1;
print "$title"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $Indication_ID = $f[0];
         my $Indication = $f[1];
         my $k = "$Indication_ID\t$Indication";
         my $DOID = $f[2];
         my $DO_term = $f[3];
         my $v = "$DOID\t$DO_term";
         $hash1{$k} = $v;
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
         my $HPOID = $f[2];
         my $HPO_term = $f[3];
         my $v = "$HPOID\t$HPO_term";
         $hash2{$k} = $v;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my $v = $hash1{$ID};
        print $O1 "$ID\t$v\t$s\n";
    } 
}



# foreach my $ID (sort keys %hash5){
#     if (exists $hash4{$ID}){
#         my $s = $hash4{$ID};
#         $hash7{$ID} = $s;
#     } 
#     else {
#         my $v = "NA\tNA";
#         $hash7{$ID} =$v；
#     }
# }

# foreach my $ID (sort keys %hash6){
#     if (exists $hash7{$ID}){
#         my $s = $hash6{$ID};
#         my $v = $hash7{$ID};
#         print STDERR "$ID\t$s\t$v\n";
#     }
# }

