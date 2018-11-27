
#将mapin的do成功的和失败的写在一个文件里。
#将mapin的hpo成功的和失败的写在一个文件里。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f2 ="./huan_mapin_do_success_indication1.txt";
my $f4 ="./huan_mapin_hpo_success_indication1.txt";
my $f5 ="./huan_used_mapin.txt";
my $fo1 = "./huan_mapin_do.txt"; #mapin do 的所有数据。
my $fo2 = "./huan_mapin_hpo.txt";#mapin hpo 的所有数据。
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

#my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\n";
select $O1;
print "Indication_ID\tIndication\tDOID\tDO_term\n"; 
select $O2;
print "Indication_ID\tIndication\tHPO_ID\tHPO_term\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I2>)
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
         push@{$hash2{$k}}, $v;
     }
}


while(<$I4>)
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
         push@{$hash4{$k}},$v;
     }
}

while(<$I5>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $Indication_ID = $f[0];
         my $Indication = $f[1];
         my $k = "$Indication_ID\t$Indication";
         $hash5{$k} = 1;
     }
}

my @id;
my @term;
foreach my $ID (sort keys %hash5){
    if (exists $hash2{$ID}){
        my @DOs= @{$hash2{$ID}};
        foreach my $do(@DOs){
            my @fi= split/\t/,$do;
                push  @{$hash6{$ID}},$fi[0];
                push  @{$hash7{$ID}},$fi[1];
        }
         my @id = @{$hash6{$ID}};
         my @term = @{$hash7{$ID}};
         my $ids = join("|", @id); #使一行对应多个trait的disease，do或者hpo后也在一行中。
         my $terms = join("|",@term);
         print $O1 "$ID\t$ids\t$terms\n";

    } 
    else {
        my $s = "$ID\tNA\tNA";
        print $O1 "$s\n";
    }
}

@id =();
@term = ();
my (%hash8,%hash9);
foreach my $ID (sort keys %hash5){
    if (exists $hash4{$ID}){
       my @HPOs= @{$hash4{$ID}};
        foreach my $hpo(@HPOs){
            my @fi= split/\t/,$hpo;
                push  @{$hash8{$ID}},$fi[0];
                push  @{$hash9{$ID}},$fi[1];
        }
         my @id = @{$hash8{$ID}};
         my @term = @{$hash9{$ID}};
         my $ids = join("|", @id); #使一行对应多个trait的disease，do或者hpo后也在一行中。
         my $terms = join("|",@term);
         print $O2 "$ID\t$ids\t$terms\n";
    } 
    else {
        my $s = "$ID\tNA\tNA";
        print $O2 "$s\n";
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

