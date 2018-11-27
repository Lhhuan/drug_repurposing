#把coding的tsv文件CosmicMutantExport.tsv.gz（带有mutation id 和 tumor type）和noncoding文件CosmicNCV.tsv.gz merge 起来，得文件01_merge_coding_and_noncoding_mutation_id_cancer_type.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
use Compress::Zlib;

my $f1 ="./CosmicMutantExport.tsv.gz"; #
my $gz1 = gzopen($f1, "rb")or die "Cannot open $f1: $gzerrno\n" ;
my $f2 ="./CosmicNCV.tsv.gz";
my $gz2 = gzopen($f2, "rb")or die "Cannot open $f2: $gzerrno\n" ;

my $fo1 = "./01_merge_coding_and_noncoding_mutation_id_cancer_type.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


print $O1 "Mutation_id\tprimary_site\tSite_subtype_1\tSite_subtype_2\tSite_subtype_3\tPrimary_histology\tHistology_subtype_1\tHistology_subtype_2\tHistology_subtype_3\n";


# while(<$DATE1>){
while ($gz1->gzreadline($_) > 0) {
    chomp;
    my @f= split /\t/;
    unless(/^Sample*name/){
         
         my $primary_site = $f[7];
         my $Site_subtype_1 =$f[8];
         my $Site_subtype_2 = $f[9];
         my $Site_subtype_3 = $f[10];
         my $Primary_histology =$f[11];
         my $Histology_subtype_1 =$f[12];
         my $Histology_subtype_2 = $f[13];
         my $Histology_subtype_3 = $f[14];
         my $mutation_id = $f[16];
         my $cancer_type = join("\t",@f[7..14]);
         my $output = "$mutation_id\t$cancer_type";
         print $O1 "$output\n";
    }
}
die "Error reading from $f1: $gzerrno\n" if $gzerrno != Z_STREAM_END ;
$gz1->gzclose() ;

# while(<$DATE2>){
while ($gz2->gzreadline($_) > 0) {
    chomp;
    my @f= split /\t/;
    unless(/^Sample*name/){
         my $primary_site = $f[3];
         my $Site_subtype_1 =$f[4];
         my $Site_subtype_2 = $f[5];
         my $Site_subtype_3 = $f[6];
         my $Primary_histology =$f[7];
         my $Histology_subtype_1 =$f[8];
         my $Histology_subtype_2 = $f[9];
         my $Histology_subtype_3 = $f[10];
         my $mutation_id = $f[11];
         my $cancer_type = join("\t",@f[3..10]);
         my $output = "$mutation_id\t$cancer_type";
         print $O1 "$output\n";
    }

}

die "Error reading from $f2: $gzerrno\n" if $gzerrno != Z_STREAM_END ;
$gz2->gzclose() ;

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
