#把文件01_gene_variant_type.txt中mutation和truncating_mutations 的特定类型筛选出来
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../01_cosmic_coding_path_info.txt";
my $fo1 = "./01_synonymous.txt";
my $fo2 = "./01_non-synonymous.txt";
my $fo3 = "./01_gene_transcript.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my $title = "symbol\tgene\ttranscript\tSample\tct\tposition\n";

select $O1;
print $title;
select $O2;
print $title;
my(%hash1,%hash2,%hash3);
select $O3;
print "Symbol\tEnsembl_Transcript_ID\tCDS_Length\n" ;                  
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^position/){
         my $position = $f[0];
         my $gene = $f[3];
         my $transcript = $f[4];
         my $ct = $f[5];
         my $symbol = $f[6];
         my $Sample = $f[7];
         my $CDS_position = $f[8];
         my $Protein_position = $f[9];
         #my $output = "$symbol\t$gene\t$transcript\t$Sample\t$ct\t$position";
         if ($ct  =~ /synonymous_variant/){
             $ct =~ s/synonymous_variant/synonymous/g;
             my @p =split/\//,$Protein_position;
             print $O1 "$symbol\t$gene\t$transcript\t$Sample\t$ct\t$p[0]\n";
         }
         if ($ct =~ /missense_variant/){
             $ct =~ s/missense_variant/non-synonymous/g;
             my @p =split/\//,$Protein_position;
             print $O2 "$symbol\t$gene\t$transcript\t$Sample\t$ct\t$p[0]\n";
         }
         elsif($ct =~ /stop/){
             $ct =~ s/stop*/stop/g;
             my @p =split/\//,$Protein_position;
             print $O2 "$symbol\t$gene\t$transcript\t$Sample\t$ct\t$p[0]\n";
        }

        unless($CDS_position=~ /-/){
            my @p =split/\//,$CDS_position;
            print $O3 "$symbol\t$transcript\t$p[1]\n"

        }
     }
}                    


