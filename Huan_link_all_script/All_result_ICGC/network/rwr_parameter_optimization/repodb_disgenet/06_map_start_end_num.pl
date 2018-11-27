#把05_test_start_end_entrezid_group.txt的start和end换成在网络中的id
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./05_test_start_end_entrezid_group.txt"; 
my $f2 ="./network_gene_num.txt";
my $fo1 ="./06_test_start_end_num.txt"; 
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
    if (/^drug_name/){
        print $O1 "$_\n"
    }
    else{
        #  my $start = $f[0];
         my $drug = $f[0];
         my $drug_target = $f[1];
         my $disease = $f[2];
         my $disease_gene = $f[3];
         my $end_info= join("\t",@f[0,2,3]);
        push @{$hash1{$drug_target}},$end_info;
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
    if (exists $hash2{$ID}){
        my $start_id = $hash2{$ID};
        my @end_infos =@{$hash1{$ID}};
        foreach my $end_info(@end_infos){
            my $group1 = "$start_id\t$end_info";
            my @f=split/\t/,$group1;
            my $start= $f[0];
            my $drug =$f[1];
            my $disease = $f[2];
            my $end =$f[3];
            my $vg= join("\t",@f[0..2]);
            push @{$hash3{$end}},$vg;
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
            my $end = $f[0];
            my $start = $f[1];
            my $drug =$f[2];
            my $disease = $f[3];
            print $O1 "$drug\t$start\t$disease\t$end\n";
        }
    }
}

            
