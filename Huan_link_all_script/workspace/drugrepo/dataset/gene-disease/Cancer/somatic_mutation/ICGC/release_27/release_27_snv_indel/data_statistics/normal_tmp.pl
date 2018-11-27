
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./final_oncotree-id_mutation_num_m1.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo2 ="./final_oncotree-id_mutation_num_m2.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
 print $O2 "project\tinvolve_mutationID_num\n";

 my %hash1;
 my %hash2;
 my %hash3;
 my %hash4;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_id_label/){
        my $project = $f[2];
        my $involve_mutationID_num = $f[1];
        my $count = $involve_mutationID_num / 19;
    
        $count=sprintf "%.0f",$count;
        print $O2 "$project=$count\t$count\n";
    }
}


