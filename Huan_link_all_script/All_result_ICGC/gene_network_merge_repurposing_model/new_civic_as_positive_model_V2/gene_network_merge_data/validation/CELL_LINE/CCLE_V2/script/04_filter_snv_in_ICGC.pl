#用../output/snv_sample.txt 和
#../../../Actionable_mutation_TCGA_28847918/output/07_ICGC_mutation_id_HGVSg.txt 根据hgvsg
#取overlap得../output/04_filter_snv_in_icgc.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../../Actionable_mutation_TCGA_28847918/output/07_ICGC_mutation_id_HGVSg.txt";
my $f2 ="../output/snv_sample.txt";
my $fo1 ="../output/04_filter_snv_in_icgc.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        my $HGVSg = $f[1];
        push @{$hash1{$HGVSg}},$Mutation_ID;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^CCLE_name/){
        print $O1 "$_\tMutation_ID\n";
    }
    else{
        my $hgvsg = $f[1];
        if(exists $hash1{$hgvsg}){
            my @Mutation_IDs = @{$hash1{$hgvsg}};
            foreach my $Mutation_ID(@Mutation_IDs){
                print $O1 "$_\t$Mutation_ID\n";
            }
        }
        else{
            print STDERR "$hgvsg\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

