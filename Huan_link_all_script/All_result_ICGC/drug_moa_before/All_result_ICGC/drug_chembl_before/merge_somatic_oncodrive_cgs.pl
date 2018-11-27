##将oncodriverole_gene_role.txt和cancer_gene_census_role.txt写在一个文件里。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./oncodriverole_gene_role.txt";
my $f2 ="./cancer_gene_census_role.txt";
my $fo1 ="./somatic_gene_role.txt"; #将oncodriverole_gene_role.txt和cancer_gene_census_role.txt写在一个文件里。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Gene_symbol\tProb_Act\tProb_LoF\tRole_in_cancer\tSource";
select $O1;
print "$title\n";
#my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
     unless(/^Gene_symbol/){
         print $O1 "$_\toncodriverole\n";
         
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene_Symbol/){
          for (my $i=0;$i<2;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }

         my $Gene_Symbol = $f[0];
         my $Role_in_Cancer = $f[1];
         my $k = "$Gene_Symbol\tNA\tNA\t$Role_in_Cancer\tcancer_gene_census"; #没有的Prob_Act\tProb_LoF用NA填充。
         print $O1 "$k\n";
     }
}
