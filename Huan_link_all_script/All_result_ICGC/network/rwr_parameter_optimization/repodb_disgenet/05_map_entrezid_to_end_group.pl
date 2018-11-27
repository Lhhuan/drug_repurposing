#把02_uni_start_end_info.txt换成entrezid；得文件05_test_start_end_entrezid_group.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./02_uni_start_end_info.txt"; 
my $f2 ="./02_unique_end_symbol_to_entrez.txt";
my $fo1 ="./05_test_start_end_entrezid_group.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
# print "start\tend\n"; 


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if (/^drug_name/){
        print $O1 "$_\n"
    }
    else{
        #  my $start = $f[0];
         my $drug = $f[0];
         my $drug_target = $f[1];
         my $disease = $f[2];
         my $start= join("\t",@f[0..2]);
         my $end_symbol = $f[3];
        push @{$hash1{$end_symbol}},$start;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/query/){
         my $symbol = $f[0];
         my $entrez = $f[3];
         $hash2{$symbol}=$entrez;
     }
}

foreach my $end_symbol (sort keys %hash1){
    if(exists $hash2{$end_symbol}){
         my @starts = @{$hash1{$end_symbol}};
         my $end_entrez= $hash2{$end_symbol};
         foreach my $start(@starts){
             my @f=split/\t/,$start;
             unless($end_entrez == $f[1]){ #如果start不等于end，数据证明，不存在start=end
            #  print STDERR "$f[1]\n";
                 my $output = "$start\t$end_entrez";
                 unless(exists $hash3{$output}){
                        print $O1 "$output\n";
                        $hash3{$output}=1;
                }
             }
         }
    } 
}
