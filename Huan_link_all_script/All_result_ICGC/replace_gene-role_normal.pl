#把judge_somatic_path_gene_role.txt中的所有的role统一成LOF和GOF,得文件 judge_somatic_path_gene_role_normal.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./judge_somatic_path_gene_role.txt";
my $fo1 ="./judge_somatic_path_gene_role_normal.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "Chrom:pos.alt.ref\tMutation_id\tENSG_ID\tSymbol\tEntrez_ID\tRole_in_cancer\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Chrom/){
       my $Chrom = $f[0];
       my $Mutation_id =$f[1];
       my $ENSG_ID = $f[2];
       my $Symbol = $f[3];
       my $Entrez_ID = $f[4];
       my $Role_in_cancer = $f[5];
       my $k = join("\t",@f[0..4]);
       if($Role_in_cancer=~/fusion|NONE|"oncogene,/){
           print $O1 "$k\tLOF,GOF\n";
       }
       else{
           if ($Role_in_cancer=~/Loss|TSG/){
               print $O1 "$k\tLOF\n";
           }
           elsif($Role_in_cancer=~/oncogene|Oncogene|Activating/)
           {
            print $O1 "$k\tGOF\n";
           }
       }
    }
}












