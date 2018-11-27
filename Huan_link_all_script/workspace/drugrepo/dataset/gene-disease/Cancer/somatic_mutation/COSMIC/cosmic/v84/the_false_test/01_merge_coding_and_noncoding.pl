#把coding的tsv文件CosmicMutantExport.tsv.gz（带有variant id 和id_tumor）和noncoding文件CosmicNCV.tsv.gz merge 起来，得文件01_merge_coding_and_noncoding_id_tumor.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
my $fo1 = "./01_merge_coding_and_noncoding_id_tumor.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $DATE1, 'zcat CosmicMutantExport.tsv.gz|' or die "zcat CosmicMutantExport.tsv.gz $0: $!\n"; 
open my $DATE2, 'zcat CosmicNCV.tsv.gz|' or die "zcat CosmicNCV.tsv.gz $0: $!\n"; 
select $O1;
print "ID_sample\tID_tumour\tmutation_id\tmutation_pos\n";


while(<$DATE1>){
    chomp;
    my @f= split /\t/;
    unless(/^Gene/){
         my $ID_sample = $f[5];
         my $ID_tumour = $f[6];
         my $mutation_id = $f[16];
         my $mutation_pos =$f[23];
         my $output = "$ID_sample\t$ID_tumour\t$mutation_id\t$mutation_pos";
         print $O1 "$output\n";
    }
}

while(<$DATE2>){
    chomp;
    my @f= split /\t/;
    unless(/^Sample/){
         my $ID_sample = $f[1];
         my $ID_tumour = $f[2];
         my $mutation_id = $f[11];
         my $mutation_pos =$f[14];
         my $output = "$ID_sample\t$ID_tumour\t$mutation_id\t$mutation_pos";
         print $O1 "$output\n";
    }

}



