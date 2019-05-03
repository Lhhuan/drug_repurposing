##将在ICGC中的actionable 和driver mutation merge 到一起。将../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt
#和../../driver_mutation/hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt merge到一起，
#得./output/01_all_driver_action_in_ICGC.txt ,得unique的mutation 文件得./output/01_unique_all_driver_action_in_ICGC.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt";
my $f2 = "../../driver_mutation/hit_all_ICGC_mutation/output/04_actionable_mutaton_in_pathogenicity.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/01_all_driver_action_in_ICGC.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/01_unique_all_driver_actionable_in_ICGC.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "variant_id\tfinal_variant\thgvsg\tICGC_Mutation_ID\tsource";
print  $O1 "$header\n";
print $O2 "ICGC_Mutation_ID\n";



while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tactionable_mutation\n";
        my $ICGC_Mutation_ID = $f[3];
        $hash1{$ICGC_Mutation_ID}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tdriver_mutation\n";
        my $ICGC_Mutation_ID = $f[3];
        $hash1{$ICGC_Mutation_ID}=1;
    }
}

foreach my $id (sort keys %hash1){
    print $O2 "$id\n";
}