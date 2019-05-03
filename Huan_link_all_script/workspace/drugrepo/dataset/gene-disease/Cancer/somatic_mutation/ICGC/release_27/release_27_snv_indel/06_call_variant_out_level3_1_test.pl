#把05_varint_out_level3_1.vcf根据mutation_id，simple_somatic_mutation.largethan1.vcf把其他的mutation的info补齐，得文件06_varint_out_level3_1_info.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./05_varint_out_level3_1.vcf";
my $f2 = "./simple_somatic_mutation.largethan1.vcf";
my $fo1 = "./06_varint_out_level3_1_info.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);




while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    my $mutation_id =$f[0];
    #print STDERR "$mutation_id\t1223\n";
    $hash1{$mutation_id} =1;
}

while(<$I2>)
{
    chomp;
    if (/^#/){
        print $O1 "$_\n";
        print STDERR  "$_\n";
    }
    else{
        my @f =split/\s+/;
        my $Extra = $f[13];
        my $variation_id = $f[2];
        if (exists $hash1{$variation_id}){
            print $O1 "$_\n";
        }
    }
}
