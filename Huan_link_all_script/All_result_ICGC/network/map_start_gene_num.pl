#将uni_network_start.txt的gene换成id，得文件start_network_num.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./uni_network_start.txt";
my $f2 ="./network_gene_num.txt";
my $fo1 ="./start_network_num.txt"; #有number 的start gene, 
my $fo2 ="./no_start_network_num.txt"; #没有number，即在网络中没有这个基因，这个基因不能作为起点。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

#select $O1;
#print "$title\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my $gene= $_;
    $gene = uc($gene);
    $hash1{$gene} = 1;
    #print $O2 "$gene\n";

}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene/){
         my $gene = $f[0];
         $gene = uc($gene);
         my $id = $f[1];
         $hash2{$gene} = $id;
     }
}

#对第一列基因进行id的转换
foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        #print $O1 "$ID\t$s\n";
        print $O1 "$s\n";
    } 
    else{
        print $O2 "$ID\n";
    }

}




