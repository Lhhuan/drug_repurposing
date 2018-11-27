#将CLUE_REPURPOSING_indication_target.txt文件中加入ensg_id 一列。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./oncokb_CancerGenesList.txt";
my $f2 ="./somatic_gene_role.txt";
my $fo1 ="./oncokb_CancerGenesList_v2.txt"; #处理后的oncokb_CancerGenesList.txt
my $fo2 ="./oncokb_somatic_gene_role.txt";#oncokb 和cosmic中都有的具有oncorole 的基因。
my $fo3 ="./oncokb_single_s_gene_role.txt";#只在oncokb中存在，不在cosmic中存在的具有oncorole 的基因
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

#my $title = "chembl_id\tdrug_name\tmoa\tgene_symbol\tdisease_area\tindication\tphase\tensg_id";
select $O1;
print "Gene\tRole\n";
select $O2;
print "Gene\tRole_somatic\tRole_oncokb\n";
select $O3;
print "Gene\tRole\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>) #先把格式不规整的oncokb_CancerGenesList_v2.txt进行处理，结果存在到oncokb_CancerGenesList_v2.txt中
{
    chomp;
    my @f= split /\t/;
     unless(/^Hugo/){
         my $gene = $f[0];
         my $Oncogene = $f[3];
         my $TSG = $f[4];
         if($Oncogene=~/Yes/){
             print $O1 "$gene\tOncogene\n";
         }
         elsif($TSG=~/Yes/){
             print $O1 "$gene\tTSG\n";
         }
     }
}
close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene/){
         my $Symbol = $f[0];
         $Symbol = uc($Symbol);
         my $role = $f[3];
         $hash2{$Symbol} = $role;
     }
}

my $f3 ="./oncokb_CancerGenesList_v2.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n"; #处理后的oncokb_CancerGenesList.txt读进来。
#print STDERR "123\n";

while(<$I3>)
{
    #print STDERR "123\n";
    chomp;
    my @f= split /\t/;
     unless(/^Gene/){
         my $Symbol = $f[0];
         $Symbol = uc($Symbol);#把symbol都转换成大写。
         my $role = $f[1];
         $hash3{$Symbol} = $role;
         #print STDERR "$Symbol\n";
     }
}

foreach my $ID (sort keys %hash3){
    if (exists $hash2{$ID}){
        my $v2= $hash2{$ID};
        my $v3 = $hash3{$ID};
        print $O2 "$ID\t$v2\t$v3\n";
    } 
    else {
        my $v3= $hash3{$ID};
        print $O3 "$ID\t$v3\n";
        
    }
}

