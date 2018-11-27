##把three_source_gene_role_final.txt和three_source_gene_role_ensg.txt merge在一起，得文件three_source_gene_role_symbol_ensg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./three_source_gene_role_final.txt";
my $f2 ="./three_source_gene_role_ensg.txt";
my $fo1 ="./three_source_gene_role_symbol_ensg.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "symbol\tProb_Act\tProb_LoF\tRole_in_cancer\tSource\tENSG_ID\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene_symbol/){
         my $symbol = $f[0];
         my $Prob_Act =$f[1];
         my $Prob_LoF = $f[2];
         my $Role_in_cancer = $f[3];
         my $Source = $f[4];
         my $k = join ("\t",@f[1..4]);
         $hash1{$symbol}=$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $symbol = $f[0];
         my $ensg = $f[1];
        #  $ensg_id =~ s/"list\(gene//g;
        #  $ensg_id =~ s/\s+//g;
        #  $ensg_id =~ s/"//g;
        #  $ensg_id =~ s/\)//g;
        #  $ensg_id =~ s/\(//g;
        #  $ensg_id =~ s/\=//g;
        #  $ensg_id =~ s/c//g;
        #  my @e = split/,/,$ensg_id;
        #  my $ensg = $e[0];
        #  print "$ensg\n";
        $ensg =~ s/\s+//g;
       $ensg =~ s/c\("//g;
       $ensg =~ s/"//g;
       $ensg =~ s/,.*$//g;#只取转换过的第一个ensgid
       #print STDERR "$ensg\n";
       if($ensg=~/ENSG/){
           $hash2{$symbol} = $ensg;
       }
        # $hash2{$symbol} = $ensg;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $ensg = $hash2{$ID};
        my $symbol = $hash1{$ID};
        print $O1 "$ID\t$symbol\t$ensg\n";
    } 
    else {
        my $symbol = $hash1{$ID};
        print $O1 "$ID\t$symbol\tNA\n";
    }
}

