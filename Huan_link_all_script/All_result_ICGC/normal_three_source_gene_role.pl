#把three_source_gene_role_symbol_ensg.txt文件中的gene role都统一成LOF,和GOF,得文件normal_three_source_gene_role.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./three_source_gene_role_symbol_ensg.txt";
my $fo1 ="./normal_three_source_gene_role.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "symbol\tProb_Act\tProb_LoF\tRole_in_cancer\tSource\tENSG_ID\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^symbol/){
       my $symbol = $f[0];
       my $Prob_Act =$f[1];
       my $Prob_LoF = $f[2];
       my $Role_in_cancer = $f[3];
       my $Source = $f[4];
       my $ENSG_ID = $f[5];
       my $k1 = join("\t",@f[0..2]);
       my $k2 = join("\t",@f[4,5]);
       if($Role_in_cancer=~/fusion|NONE|"oncogene,/){
           print $O1 "$k1\tLOF,GOF\t$k2\n";
       }
       else{
           if ($Role_in_cancer=~/Loss|TSG/){
               print $O1 "$k1\tLOF\t$k2\n";
           }
           elsif($Role_in_cancer=~/oncogene|Oncogene|Activating/)
           {
            print $O1 "$k1\tGOF\t$k2\n";
           }
           else{
               print $O1 "$_\n";
           }
       }
    }
}












