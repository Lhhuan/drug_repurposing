#为调参的start和end的gene symbol转换成entrez和在网络中的编号。分别得文件03_test_symbol_to_entrez_networkid.txt和03_test_start_end_networkid.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./02_testgene_list_symbol_to_entrez.txt";
my $f2 ="../network_gene_num.txt";
my $f3 ="./start_end.txt";
my $fo1 ="./03_test_symbol_to_entrez_networkid.txt"; 
my $fo2 ="./03_test_start_end_networkid.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "symbol\tentrezid\tid\n"; 
select $O2;
print "start_id\tend_id\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $symbol = $f[0];
         my $entrezgene = $f[3];
         $hash1{$entrezgene}=$symbol;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrezgene = $f[1];
         my $id = $f[2];
         #my $id = $f[1];
         $hash2{$entrezgene} = $id;
     }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^target/){
         my $start = $f[0];
         my $end = $f[1];
        push@{$hash3{$start}},$end;
     }
}

foreach my $entrezid (sort keys %hash1){
    if (exists $hash2{$entrezid}){
        my $id = $hash2{$entrezid};
        my $symbol =$hash1{$entrezid};
        print $O1 "$symbol\t$entrezid\t$id\n";
        $hash4{$symbol}=$id;
    } 
}




#对第一列基因进行id的转换
foreach my $start (sort keys %hash3){
    if (exists $hash4{$start}){
       # print STDERR "$start\n";
        my @ends = @{$hash3{$start}};
        my $start_id = $hash4{$start};
        foreach my$end (@ends){
            push@{$hash5{$end}},$start_id;

            #print STDERR "$start_id\t$end\n";
        }
    } 
}
# #对第二列基因进行转换
foreach my $end (sort keys %hash5){
    if (exists $hash4{$end}){
        #print STDERR "$end\n";
        my @start_ids = @{$hash5{$end}};
        my $end_id = $hash4{$end};
        foreach my $start_id(@start_ids){
            print $O2 "$start_id\t$end_id\n";

        } 
    } 
}

            



