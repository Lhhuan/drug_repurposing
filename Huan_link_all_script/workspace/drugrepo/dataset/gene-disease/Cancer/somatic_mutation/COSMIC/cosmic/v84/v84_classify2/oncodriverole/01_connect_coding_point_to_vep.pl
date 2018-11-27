#把文件cosmic_coding_path.txt中的数据所对应的Cosmic_all_ref_alt.txt中的信息提出来。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./cosmic_coding_path.txt";
my $f2 ="./Cosmic_all_ref_alt.txt";
my $fo1 = "./01_cosmic_coding_path_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "position\tref\talt\tENSG_ID\tENST_ID\tvariant_type\tsymbol\tsample_id\tCDS_position\tProtein_position\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    $hash1{$_}=1;
}
                
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^position/){
         my $position = $f[0];
         my $ref = $f[1];
         my $alt = $f[2];
         my $sample_id = $f[3];
         my $ENSG_ID = $f[5];
         my $ENST_ID = $f[6];
         my $variant_type = $f[7];
         my $symbol = $f[8];
         my $CDS_position = $f[9];
         my $Protein_position = $f[10];
         my $header = "$position\t$ref\t$alt\t$ENSG_ID\t$ENST_ID\t$variant_type\t$symbol\t$sample_id\t$CDS_position\t$Protein_position";
         my $ID = "$position\.$ref\.$alt";
        push @{$hash2{$ID}},$header;                       
     }
}                    


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my @value = @{$hash2{$ID}};
        foreach my $t(@value){
            print "$t\n";
        }    
    }
}