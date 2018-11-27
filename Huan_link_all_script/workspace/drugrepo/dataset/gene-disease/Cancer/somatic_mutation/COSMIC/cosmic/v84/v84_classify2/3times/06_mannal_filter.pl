
# 为cosmic_all_no_spzdex_score.txt进行筛选。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./cosmic_all_no_spzdex_score.txt";
my $fo1 = "./cosmic_mannal.txt";
my $fo2 = "./cosmic_no_mannal.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "chr:pos.ref.alt\tID\tENSG_ID\tvariant_type\tsymbol\n";
select $O1;
print $title ;
select $O2;
print $title ;
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^chr/){
         my $chr_pos_ref_alt = $f[0];
         my $ID = $f[1];
         my $ENSG_ID = $f[2];
         my $variant_type = $f[3];
         my $symbol = $f[4];
         if($variant_type =~/stop_gained|stop_lost|start_lost|frameshift_variant|transcript_ablation|transcript_amplification|inframe_insertion|inframe_deletion/){ #将veo为这些类型的筛出来
             print $O1 "$_\n";
         }
         else{
             print $O2 "$_\n";
         }
     }
}

