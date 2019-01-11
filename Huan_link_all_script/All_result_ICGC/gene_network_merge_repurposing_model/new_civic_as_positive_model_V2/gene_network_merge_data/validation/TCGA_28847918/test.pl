
my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan1.vcf";
my $f2 = "./output/05_28847918_snv.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/05_filter_snv_ref_alt.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $chr = $f[4];
        my $start = $f[5];
        my $end =$f[6];
        my $ccc = $end - $start;
        unless(exists $hash1{$ccc}){
            $hash1{$ccc} =1;
            print $O1 "$ccc\n";
        }
    }
}
