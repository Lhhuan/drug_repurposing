#判断atrial_fibrillation_related_gene.txt 是否在drug_target_info.txt，得在的文件11_atrial_fibrillation_drug_target_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./drug_target_info.txt";
my $f2 = "./atrial_fibrillation_related_gene.txt";
my $fo1 = "./11_atrial_fibrillation_drug_target_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


print $O1 "Symbol\tEntrez\tMOA\tDrug\tENSG\tMutation_map_to_gene_level\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $drug =  $f[3];
    push @{$hash1{$drug}},$_;
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    my $ensg = $f[0];
    my $levels = $f[1];
    push @{$hash2{$ensg}},$levels;
}

foreach my $drug (sort keys %hash1){
    my @targets= @{$hash1{$drug}};
    foreach my $target(@targets){
        my @f = split/\t/,$target;
        my $ensg = $f[-1];
        if (exists $hash2{$ensg}){
            my @levels = @{$hash2{$ensg}};
            my $v = join(",",@levels);
            print $O1 "$target\t$v\n";
        }
    }
}

