#将FIsInGene_022717_with_annotations.txt的gene换成id。。 这个是训练nb_lin.m所需要的文件。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./normal_network.txt";
my $f2 ="../network_gene_num.txt";
my $fo1 ="./normal_network_num.txt"; #将normal_network.txt的gene换成id。#header = "id1\tid2\tweight\n" #这里的weight是两个节点之间的probility(可能性)转化而来。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "start\tend\tweight\tdirection\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene1/){
         my $gene1 = $f[0];
         $gene1 =~s/\s+/-/g;
         my $gene2 = $f[1];
         $gene2 =~s/\s+/-/g; #这里其实不必再转换
         my $weight = $f[2];#probility越大，weight 越小。
        #  my $weight = 1-$probility ; 
        #  $weight = $weight*10000;#为了和后面一致，达到和后面同样的weight倍数，故在此*10000
         #my $weight = exp(-$probility);
         #print STDERR "$probility\t$weight\n";
         $weight = sprintf "%.4f",$weight;
         $weight = $weight*10000;
         my $direction = $f[3];
        #  $weight = $weight;
         #$weight =1;#因为rwr不需要weight,而这里的输入有要weight，给所有的weight 为1
         my $v = "$gene2\t$weight\t$direction";

         #my $v = join ("\t", @f[1,2]);
         push @{$hash1{$gene1}},$v;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $gene = $f[0];
         my $id = $f[2];
         $hash2{$gene} = $id;
     }
}

#对第一列基因进行id的转换
foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            my $group1 = "$s\t$v";
            my @f= split/\t/,$group1;
            my $gene2 = $f[1];
            my $vg = join ("\t", @f[0,2,3]); #$f[0]是原来表格中的gene1转换后的id，也就是$s,
            push @{$hash3{$gene2}},$vg;
            #print STDERR "$group1";
        }
    } 
}
#对第二列基因进行转换
foreach my $ID (sort keys %hash3){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash3{$ID}};
        foreach my $v(@v){
            my $group2 = "$s\t$v";
            my @f=split/\t/,$group2;
            my $gene2 = $f[0];
            my $gene1 = $f[1];
            my $weight = $f[2];
            my $direction =$f[3];
            print $O1 "$gene1\t$gene2\t$weight\t$direction\n";
        }
    }
}

            