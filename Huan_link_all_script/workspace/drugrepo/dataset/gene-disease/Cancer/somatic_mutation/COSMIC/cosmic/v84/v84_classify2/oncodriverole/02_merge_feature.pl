#把三个文件mergr起来 ，获得最终用于run oncodriverule的数据
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CNA_cbs_logratio_GvL/01_CNA_cbs_logratio_GvL.txt";
my $f2 ="./MUTS_trunc_mutfreq/03_MUTS_trunc_mutfreq.txt";
my $f3 ="./oncodrivecluster/04_MUTS_clusters_miss_VS_pam.txt";
my $fo1 = "./02_feature_oncodriverule.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "ensg\tsym\tMUTS_trunc_mutfreq\tMUTS_clusters_miss_VS_pam\tCNA_cbs_logratio_GvL\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
       

while(<$I1>)  #CNA
{
    chomp;
    my @f= split /\t+/;
     unless(/^gene_name/){
         my $gene_name = $f[0];
         my $CNA_cbs_logratio_GvL = $f[1];
         $hash1{$gene_name} = $CNA_cbs_logratio_GvL; 
     }
}                    

while(<$I2>) #03_MUTS_trunc_mutfreq.txt
{
    chomp;
    my @f= split /\s+/;
     unless(/^ENSG_ID/){
         my $ENSG_ID = $f[0];
         my $symbol = $f[1];
         my $MUTS_trunc_mutfreq = $f[2];
         my $ID = "$ENSG_ID\t$symbol";
         $hash2{$ID}=$MUTS_trunc_mutfreq;                 
     }
}                    

while(<$I3>) #04_MUTS_clusters_miss_VS_pam.txt
{
    chomp;
    my @f= split /\s+/;
     unless(/^ENSG_ID/){
         my $ENSG_ID = $f[0];
         my $symbol = $f[1];
         my $MUTS_clusters_miss_VS_pam = $f[2];
         my $ID = "$ENSG_ID\t$symbol";
         $hash3{$ID}=$MUTS_clusters_miss_VS_pam;  
         
     }
}            

foreach my $ID (sort keys %hash3){
    if (exists $hash2{$ID}){
        my $v3 = $hash3{$ID};
        my $v2 = $hash2{$ID};
        my @p= split /\t/,$ID;
        my $k1 = $p[1];
        if (exists $hash1{$k1}){
            my $v1= $hash1{$k1};
            print $O1 "$ID\t$v2\t$v3\t$v1\n";

        }
    }
}