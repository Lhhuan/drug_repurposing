##将在ICGC中的actionable 和driver mutation merge 到一起。将../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt
#和../../driver_mutation/hit_all_ICGC_mutation/output/05_out_in_ICGC_filter_disease.txt merge到一起，
#得./output/01_all_driver_action_out_ICGC.txt ,得unique的mutation disease 文件得./output/01_unique_driver_actionable_disease_out_ICGC.txt   得unique的mutation 文件得./output/01_unique_all_driver_actionable_out_ICGC.txt
#得unique的disease 文件：./output/01_unique_disease.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../../actionable_mutation/actionable_hit_all_ICGC_mutation/output/04_can_transform_actionable_mutaton_not_in_pathogenicity.txt";
my $f2 = "../../driver_mutation/hit_all_ICGC_mutation/output/05_out_in_ICGC_filter_disease.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/01_all_driver_action_out_ICGC.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/01_unique_driver_actionable_disease_out_ICGC.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 = "./output/01_unique_all_driver_actionable_out_ICGC.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my $fo4 = "./output/01_unique_disease.txt";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "variant_id\tfinal_variant\thgvsg\tdisease\tsource";
print $O1 "$header\n";
print $O2 "hgvsg\tdisease\n";
print $O3 "hgvsg\tsource\n";
print $O4 "disease\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tactionable_mutation\n";
        my $hgvsg = $f[2];
        my $disease = $f[3];
        $disease=~s/-/ /g;
        $disease=~s/_/ /g;
        $disease =lc($disease);
        my $v= "$hgvsg\t$disease";
        my $source = "actionable_mutation";
        push @{$hash1{$hgvsg}},$source;
        $hash2{$v}=1;
        $hash3{$disease}=1;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        print $O1 "$_\tdriver_mutation\n";
        my $hgvsg = $f[2];
        my $disease = $f[3];
        $disease=~s/-/ /g;
        $disease=~s/_/ /g;
        $disease =lc($disease);
        my $v= "$hgvsg\t$disease";
        my $source = "driver_mutation";
        push @{$hash1{$hgvsg}},$source;
        $hash2{$v}=1;
        $hash3{$disease}=1;
    }
}

foreach my $d_v(sort keys %hash2){
    print $O2 "$d_v\n";
}

foreach my $id (sort keys %hash1){
    my %hash7;
    my @sources = @{$hash1{$id}};
    @sources = grep { ++$hash7{$_}<2} @sources;
    my $source =join(";",@sources);
    print $O3 "$id\t$source\n";
}

foreach my $disease(sort keys %hash3){
    print $O4 "$disease\n";
}