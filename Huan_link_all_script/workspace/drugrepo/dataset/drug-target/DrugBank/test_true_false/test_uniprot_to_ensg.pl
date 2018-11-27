#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./original_uniprot_id.txt";
my $f2 ="./mart_export.txt";
my $fo1 = "./uniprot_ENSG.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "uniprot_id\tensg_id\n";


my %hash1;
my %hash2;
my %hash3;
my %hash4;



while(<$I1>)
{
    chomp;
    unless(/^name/){
        my @f = split /\t/;
        my $uniprot_id = $f[0];
        unless($uniprot_id=~/NA/){
            $hash1{$uniprot_id}=1;
        }
    }
}


while(<$I2>)
{
    chomp;
    unless(/^Gene/){
        my @f = split /\t/;
        for (my $i=0;$i<4;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
            unless(defined $f[$i]){
        $f[$i] = "NONE";
        }
        unless($f[$i]=~/\w/){$f[$i]="NONE"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
        }
        my $ensg_id = $f[0];
        my $sw_uniprot_id = $f[1];
        my $trembl_uniprot_id = $f[2];
        unless($sw_uniprot_id =~/NONE/){
             $hash2{$sw_uniprot_id} = $ensg_id;
        }
        unless($trembl_uniprot_id =~/NONE/){
            $hash3{$trembl_uniprot_id}=$ensg_id;
        }
    }
}

foreach my $uniprot_id(sort keys %hash1){
    if(exists $hash2{$uniprot_id}){
       my $ensg_id= $hash2{$uniprot_id};
       print $O1 "$uniprot_id\t$ensg_id\n";
    }
    elsif(exists $hash3{$uniprot_id}){
        my $ensg_id= $hash3{$uniprot_id};
        print $O1 "$uniprot_id\t$ensg_id\n";
    }
}

