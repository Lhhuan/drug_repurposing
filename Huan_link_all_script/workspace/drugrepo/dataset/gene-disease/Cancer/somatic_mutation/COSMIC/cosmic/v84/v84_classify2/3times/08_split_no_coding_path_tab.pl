
# 将文件unique_no_coding_path.txt按照\t分割输出。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./unique_no_coding_path.txt";
my $fo1 = "./08_split_tab_no_coding_path.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# select $O1;
# print "chr:pos.ref.alt\taaref\taaalt\trevel_score\tID\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print"chr\tpos\tref\talt\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\:/;
       my $chr = $f[0];
       my @p = split/\./,$f[1];
       my $pos = $p[0];
       my $ref = $p[1];
       my $alt = $p[2];
       my $output = "$chr\t$pos\t$ref\t$alt";
       print $O1 "$output\n";

}
          
