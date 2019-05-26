#将../in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt 和../out_ICGC/output/01_unique_all_driver_actionable_out_ICGC.txt merge 到一起，
#其中不在../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt 中 的mutation 是新加的，得./output/01_all_actionable_driver_mutation.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt";
my $f2 = "../in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt";
my $f3 = "../out_ICGC/output/01_unique_all_driver_actionable_out_ICGC.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/01_all_actionable_driver_mutation.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Mutation_id\tType\tSource\n";


my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^ICGC_Mutation_ID/){
        my $mutation_id = $f[0];
        $hash1{$mutation_id}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^ICGC_Mutation_ID/){
        my $mutation_id = $f[0];
        my $type = $f[1];
        if (exists $hash1{$mutation_id}){ #在原来的pathogenicity中
            my $output = "$_\tADD";
            print $O1 "$output\n";
        }
        else{
            print $O1 "$_\tin_ICGC\n";
        }
    }
}


while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^hgvsg/){
        my $hgvsg = $f[0];
        my $type = $f[1];
        my $variant_id = "Add"."$hgvsg";
        print $O1 "$variant_id\t$type\tADD\n";
    }
}