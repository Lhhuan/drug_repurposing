#将somatic_mutation_noncoding_path.txt和cosmic_noncoding_path_ensg_symbol_tran.txt merge起来得文件somatic_mutation_noncoding_path_final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./somatic_mutation_noncoding_path.txt";
my $f2 ="./cosmic_noncoding_path_ensg_symbol_tran.txt";
my $fo1 ="./somatic_mutation_noncoding_path_final.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "Chrom:pos.alt.ref\tMutation_id\tENSG_ID\tSymbol\n";
#select $O2;
my(%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f = split/\t/;
     unless(/^Chrom:pos.alt.ref/){
         my $pos = $f[0];
         my $Mutation_id = $f[1];
         my $ENSG_ID = $f[2];
         my $v = join ("\t",@f[0,1]);
         push@{$hash1{$ENSG_ID}}, $v;
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^ENSG_ID/){
         my $ENSG_ID = $f[0];
         my $symbol = $f[1];
         $hash2{$ENSG_ID} = $symbol;
     }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @vs= @{$hash1{$ID}};
        foreach my $v(@vs){
            print $O1 "$v\t$ID\t$s\n";
        }
        
    }
    else {
        my @vs= @{$hash1{$ID}};
        foreach my $v(@vs){
            print $O1 "$v\t$ID\tNA\n";
        }
    }
}
