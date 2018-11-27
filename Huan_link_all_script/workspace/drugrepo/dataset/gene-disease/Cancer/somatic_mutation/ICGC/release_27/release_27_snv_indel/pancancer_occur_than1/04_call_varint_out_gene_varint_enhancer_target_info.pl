# 把03_mutation_out_enhancer_target.vcf根据mutation_id，simple_somatic_mutation.largethan1.vcf把其他的mutation的info补齐，得文件04_out_gene_varint_enhancer_target_info.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./simple_somatic_mutation.largethan1.vcf";
my $f2 = "./03_mutation_out_enhancer_target.vcf";
my $fo1 = "./04_out_gene_varint_enhancer_target_info.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    if (/^#/){
        print $O1 "$_\n";
    }
     else{
         my @f =split/\s+/;
         my $variation_id = $f[2];
         my $location = $f[1];
         push @{$hash1{$variation_id}},$_;
     }
}


while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    my $mutation_id =$f[0];
    #print STDERR "$mutation_id\t1223\n";
    $hash2{$mutation_id} =1;
}

foreach my $k (sort keys %hash1){
     #print STDERR "$k\n";
    if(exists $hash2{$k}){
        # print STDERR "$k\n";
        my @infos=@{$hash1{$k}};
        foreach my $info(@infos){
            unless(exists $hash4{$info}){
                $hash4{$info}=1;
                print $O1 "$info\n";
            }
        }
    }
}
