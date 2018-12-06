#用027_gold_standard_shortest_pair.txt，029_start_end_logical.txt把符合条件的最短路径的drug_target_rwr_end逻辑根据特定药物merge产生，得0291_merge_drug_target_rwr_end_logic.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="027_gold_standard_shortest_pair.txt";
my $f2 ="./029_start_end_logical.txt";
my $fo1 ="./0291_merge_drug_target_rwr_end_logic.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug\tstart\tend\tlogic_direction\n"; 
my(%hash1,%hash2,%hash3);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $start = $f[1];
         my $end = $f[2];
         my $v = "$start\t$end";
         push @{$hash1{$drug}},$v;
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^start/){
         my $start=$f[0];
         my $end = $f[1];
         my $logic_direction = $f[2];
         my $k = "$start\t$end";
        $hash2{$k}=$logic_direction;
     }
}

foreach my $drug(sort keys %hash1){
    my @pairs = @{$hash1{$drug}};
    foreach my $pair(@pairs){
        if(exists $hash2{$pair}){
           my $logic_direction= $hash2{$pair};
           my $output= "$drug\t$pair\t$logic_direction";
            unless (exists $hash3{$output}){
                $hash3{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}