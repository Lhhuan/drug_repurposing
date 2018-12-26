
#检查huan_used_mapin_final.txt比huan_target_drug_indication_final.txt中多的indication ID
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_used_mapin_final.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./huan_target_drug_indication_final.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $indicatuion_id =$f[0];
        $hash1{$indicatuion_id}=$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $indicatuion_id =$f[-1];
         my $v= join("\t",@f[2..9]);
         $hash2{$indicatuion_id} = 1;
     }
}

foreach my $id (sort keys %hash1){
    unless(exists $hash2{$id}){
        print STDERR "$id\n";
    }
}
