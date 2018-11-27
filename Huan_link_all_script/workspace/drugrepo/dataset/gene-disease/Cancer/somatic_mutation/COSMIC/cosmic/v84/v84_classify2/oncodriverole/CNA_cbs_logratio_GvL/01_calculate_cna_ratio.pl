#将cna的gain和loss分类，并且计算CNA_cbs_logratio_GvL
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
use POSIX qw(log10);

#my $cna = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/CosmicCompleteCNA.tsv.gz" ;
open my $DATE, 'zcat /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/CosmicCompleteCNA.tsv.gz |' or die "CosmicCompleteCNA.tsv.gz  $0: $!\n"; 

# my $f1 ="/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/COSMIC/cosmic/v84/header_cna.txt";
# open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./01_CNA_cbs_logratio_GvL.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "gene_name\tCNA_cbs_logratio_GvL\n";
my(%hash1,%hash2);
while(<$DATE>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^CNV_ID/){
         my $gene_name = $f[2];
         my $key = $gene_name;
         my $ID_SAMPLE = $f[3];
         my $MUT_TYPE = $f[16];
         my $v = "$ID_SAMPLE\t$MUT_TYPE";
         if ($MUT_TYPE=~/loss/){
             push @{$hash1{$key}},$v;
         }
         if ($MUT_TYPE=~/gain/){
             push @{$hash2{$key}},$v;
         }
     }
}                    

foreach my $ID (sort keys %hash2){ #gain
    if (exists $hash1{$ID}){
        my @value_g = @{$hash2{$ID}};
        my $num_g= @value_g;
        my @value_l = @{$hash1{$ID}};
        my $num_l= @value_l;
        my $ratio = $num_g / $num_l;
        my $CNA_cbs_logratio_GvL = log10($ratio);
        print $O1 "$ID\t$CNA_cbs_logratio_GvL\n";
    }
    
}
