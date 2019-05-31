#用../output/05_28847918_snv.txt 和
#"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt"
#取overlap得../output/06_filter_snv_in_pathogenicity_icgc.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;



my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_mutation_postion.txt";
my $f2 = "../output/05_28847918_snv.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/06_filter_snv_in_pathogenicity_icgc.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Mutation_ID/){
        my $Mutation_ID = $f[0];
        my $chr = $f[1];
        my $pos = $f[2];
        my $ref = $f[3];
        my $alt = $f[4];
        my $k = "$chr\t$pos\t$ref\t$alt";
        # print STDERR "$k\n";
        $hash1{$k}=$Mutation_ID;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug/){
        print $O1 "$_\tMutation_id\n";
    }
    else{
        my $chr = $f[4];
        $chr =~ s/chr//g;
        my $start = $f[5];
        my $end =$f[6];
        my $ref = $f[7];
        my $alt =$f[8];
        my $k = "$chr\t$start\t$ref\t$alt";
        # print STDERR "$k\n";
        if (exists $hash1{$k}){
            my $id= $hash1{$k};
            # print STDERR "$k\n";
            print $O1 "$_\t$id\n";
        }

    }
}

