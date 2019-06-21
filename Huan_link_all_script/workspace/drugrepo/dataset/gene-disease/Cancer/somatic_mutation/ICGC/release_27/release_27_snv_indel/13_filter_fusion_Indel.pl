#由于13_add_indel_positive.txt 中ins和del混合的数据，这种数据在cadd里不能计算。所以只算单独ins 或者单独del的数据，得文件13_add_indel_ins_del_no_fusion.txt，del 和ins fusion 的文件13_add_indel_ins_del_fusion.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./13_add_indel_position.txt";
my $fo1 = "./13_add_indel_ins_del_fusion.txt";
my $fo2 = "./13_add_indel_ins_del_no_fusion.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
my $output = "Mutation_ID\tchr\tpos\tref\talt";
print $O1 "$output\n";
print $O2 "$output\n";
while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $Mutation_ID =$f[0];
        if ($Mutation_ID =~/ins/ && $Mutation_ID =~/del/){ ##del 和ins fusion
            print $O1 "$_\n";
        }
        else{
            print $O2 "$_\n";
        }
    }
}

