#把"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18.txt"中side effect 为cancer的药物及副作用，得文件01_filter_side_effect_from_drugbank.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18.txt";
my $fo1 ="./01_filter_side_effect_from_drugbank.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "name\tindication\tside_effect\tsource_id\n";
my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^name/){
         my $name = $f[0];
         my $indication = $f[7];
         my $side_effect = $f[8];
         my $source_id  = $f[11];
         if ($side_effect =~/cancer|tumor|oma|Neoplasm|Neoplasia/i){
             unless($side_effect=~/coma/){
                my $output = "$name\t$indication\t$side_effect\t$source_id";
                unless(exists $hash1{$output}){
                    $hash1{$output} =1;
                    print $O1 "$output\n";
                }
             }
         }
     }
}

