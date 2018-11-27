#把文件01_gene_variant_type.txt中mutation和truncating_mutations 的特定类型筛选出来
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="./02_filter_variant_truncating_mutations.txt";
my $f2 ="./02_filter_variant_mutation.txt";
my $fo1 = "./03_MUTS_trunc_mutfreq.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "ENSG_ID\tsymbol\tMUTS_trunc_mutfreq\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
                     
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^ENSG_ID/){
         my $ENSG_ID = $f[0];
         my $symbol = $f[1];
         my $variant_type = $f[2];
         my $key_t = "$ENSG_ID\t$symbol";
         push @{$hash1{$key_t}},$variant_type;  
     }
}        

while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^ENSG_ID/){
         my $ENSG_ID = $f[0];
         my $symbol = $f[1];
         my $variant_type = $f[2];
         my $key_m = "$ENSG_ID\t$symbol";
         push @{$hash2{$key_m}},$variant_type;
     }
}                   

foreach my $ID (sort keys %hash2){ #mutation
    if (exists $hash1{$ID}){
        my @value_t = @{$hash1{$ID}};
        my $num_t= @value_t;
        my @value_m = @{$hash2{$ID}};
        my $num_m= @value_m;
        my $MUTS_trunc_mutfreq = $num_t / $num_m;
        print $O1 "$ID\t$MUTS_trunc_mutfreq\n";
    }
    else{
        my $MUTS_trunc_mutfreq = 0;
        print $O1 "$ID\t$MUTS_trunc_mutfreq\n";
    }
}