#把文件01_gene_variant_type.txt中mutation和truncating_mutations 的特定类型筛选出来
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
use POSIX qw(log10);

my $f1 ="./03_gene_clust.txt";
my $fo1 = "./04_MUTS_clusters_miss_VS_pam.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "ENSG_ID\tsymbol\tMUTS_clusters_miss_VS_pam\n";   

my (%hash1,%hash2);
               
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^position/){
         my $ENSG = $f[0];
         my $symbol = $f[1];
         my $variant_type = $f[2];
         my $k = "$ENSG\t$symbol";
         if ($variant_type =~/missense_variant/){
              $hash1{$k} = $variant_type;
         }
         if($variant_type =~/frameshift_variant|stop_gained|stop_lost|splice_donor_variant|splice_acceptor_variant|missense_variant/){
             push @{$hash2{$k}},$variant_type;

         }
     }
}                    
foreach my $ID (sort keys %hash1){ 
    if (exists $hash2{$ID}){
        my @value_t = @{$hash2{$ID}};
        my $num_t= @value_t;
        my $ratio = 1/$num_t;
        my $MUTS_clusters_miss_VS_pam = log10($ratio);
        print $O1 "$ID\t$MUTS_clusters_miss_VS_pam\n";
    }
   
}

