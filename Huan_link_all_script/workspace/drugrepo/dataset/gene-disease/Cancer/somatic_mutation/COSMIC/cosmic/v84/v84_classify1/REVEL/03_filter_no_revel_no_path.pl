
# 为Cosmic_all_coding.txt 的coding variant score进行打分。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./unique_no_revel_path.txt";
my $f2 = "./Cosmic_all_coding_no_revel_no_path.txt";
my $fo1 = "./Cosmic_all_coding_no_revel_no_path1.txt";
#my $fo2 = "./Cosmic_all_coding_no_revel.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
#print "chr:pos.alt.ref\taaref\taaalt\trevel_score\tID\tENSG_ID\tvariant_type\tsymbol\n";
# select $O2;
print "chr:pos.alt.ref\tID\tENSG_ID\tvariant_type\tsymbol\n";
my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my $pos_info = $_;
    $hash1{$pos_info}=1;
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^chr/){
         my $pos = $f[0];
         my $t = join "\t", @f[1..4];
         push @{$hash2{$pos}},$t;

     }
}
  
foreach my $key (sort keys %hash2){
    unless (exists $hash1{$key}){
        my @value = @{$hash2{$key}};
        foreach my $t(@value){
            print $O1 "$key\t$t\n";
        }    
    }
}