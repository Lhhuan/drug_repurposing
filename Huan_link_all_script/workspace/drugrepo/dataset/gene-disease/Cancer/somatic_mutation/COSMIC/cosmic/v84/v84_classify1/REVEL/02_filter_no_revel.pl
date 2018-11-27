# 过滤Cosmic_all_coding_no_revel.txt中的stop_gained、stop_lost、start_lost，出现这些的认为是致病性的突变。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./Cosmic_all_coding_no_revel.txt";
my $fo1 = "./Cosmic_all_coding_no_revel_path.txt"; #致病性的突变
my $fo2 = "./Cosmic_all_coding_no_revel_no_path.txt"; #非致病性的突变
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "chr:pos.alt.ref\tID\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print  $title;
select $O2;
print  $title;
my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^chr/){
         my $variant_type = $f[3];
         if($variant_type=~/stop_gained|stop_lost|start_lost/){
             print $O1 "$_\n";
         }
         else{
             print $O2 "$_\n";
         }

     }
}
          
