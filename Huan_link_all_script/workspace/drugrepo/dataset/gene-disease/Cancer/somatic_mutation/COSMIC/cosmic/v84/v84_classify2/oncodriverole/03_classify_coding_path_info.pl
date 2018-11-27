#将01_cosmic_coding_path_info.txt分为moa，得文件03_coding_path_moa.txt，得没有moa的文件03_coding_path_no_moa.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./oncodriverole_perdiction_result.txt";
my $f2 ="./01_cosmic_coding_path_info.txt";
my $fo1 = "./03_coding_path_moa.txt";
my $fo2 = "./03_coding_path_no_moa.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "position\tref\talt\tENSG_ID\tsymbol\tmoa\n";
select $O2;
print "position\tref\talt\tENSG_ID\tsymbol\n";

my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f = split /\t/;
    unless(/^gene/){
        my $symbol  = $f[0];
        my $moa = $f[3];
        $hash1{$symbol}=$moa;
        
    }
}
                
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^position/){
         my $position = $f[0];
         my $ref = $f[1];
         my $alt = $f[2];
         my $ENSG_ID = $f[3];
         my $symbol = $f[6];
         my $v = "$position\t$ref\t$alt\t$ENSG_ID\t$symbol";
        push @{$hash2{$symbol}},$v;                       
     }
}                    


foreach my $ID (sort keys %hash2){
    if (exists $hash1{$ID}){
        my @value = @{$hash2{$ID}};
        my $v = $hash1{$ID};
        foreach my $t(@value){
           print $O1 "$t\t$v\n";
        }    
    }
    else {
        my @value = @{$hash2{$ID}};
        foreach my $t(@value){
            print $O2 "$t\n";
        }
    }
}