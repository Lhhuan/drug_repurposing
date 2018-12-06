#把01_unique_end.txt换成entrezid；得文件03_test_start_end_entrezid.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./03_test_start_end_entrezid.txt"; 
my $f2 ="./network_gene_num.txt";
my $fo1 ="./04_test_start_end_num.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
#print "start\tend\n"; 


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^start/){
         my $start = $f[0];
         my $end = $f[1];
        push @{$hash1{$start}},$end;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrez = $f[1];
         my $id = $f[2];
         $hash2{$entrez} = $id;
     }
}

#对第一列基因进行id的转换
foreach my $ID (sort keys %hash1){
    #print STDERR "$ID\n";
    if (exists $hash2{$ID}){
        #print STDERR "$ID\n";
        my $start_id = $hash2{$ID};
        my @ends =@{$hash1{$ID}};
       #  print STDERR "$start_id\n";
        foreach my $end(@ends){
            push @{$hash3{$end}},$start_id;
        }
    } 
}

#对第二列基因进行转换
foreach my $end (sort keys %hash3){
    if (exists $hash2{$end}){
        my $end_id = $hash2{$end};
        my @start_ids =@{$hash3{$end}};
        foreach my $start_id(@start_ids){
            print $O1 "$start_id\t$end_id\n";
        }
    }
}

            
