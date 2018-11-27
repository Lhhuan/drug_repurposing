#把coding的tsv文件CosmicMutantExport.tsv.gz（带有variant id 和id_tumor）和noncoding文件CosmicNCV.tsv.gz merge 起来，得文件01_merge_coding_and_noncoding_id_tumor.txt的部分信息merge在一起。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  
my $fo1 = "./03_merge_coding_and_noncoding_id_tumor_info.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $DATE1, 'zcat CosmicMutantExport.tsv.gz|' or die "zcat CosmicMutantExport.tsv.gz $0: $!\n"; 
open my $DATE2, 'zcat CosmicNCV.tsv.gz|' or die "zcat CosmicNCV.tsv.gz $0: $!\n"; 
select $O1;
print "ID_sample\tID_tumour\tmutation_id\tmutation_pos\tPrimary_site\tSite_subtype_1\tSite_subtype_2\tSite_subtype_3\tPrimary_histology\tHistology_subtype_1\tHistology_subtype_2\tHistology_subtype_3\n";
#"$ID_sample\t$ID_tumour\t$mutation_id\t$mutation_pos\t$Primary_site\t$Site_subtype_1\t$Site_subtype_2\t$Site_subtype_3\t$Primary_histology\t$Histology_subtype_1\t$Histology_subtype_2\t$Histology_subtype_3";


while(<$DATE1>){
    chomp;
    my @f= split /\t/;
    unless(/^Gene/){
         my $ID_sample = $f[5];
         my $ID_tumour = $f[6];
         my $mutation_id = $f[16];
         my $mutation_pos =$f[23];
         my $Primary_site = $f[7];
         my $Site_subtype_1 = $f[8];
         my $Site_subtype_2 = $f[9];
         my $Site_subtype_3 = $f[10];
         my $Primary_histology = $f[11];
         my $Histology_subtype_1 = $f[12];
         my $Histology_subtype_2 = $f[13];
         my $Histology_subtype_3 = $f[14];

         my $output = "$ID_sample\t$ID_tumour\t$mutation_id\t$mutation_pos\t$Primary_site\t$Site_subtype_1\t$Site_subtype_2\t$Site_subtype_3\t$Primary_histology\t$Histology_subtype_1\t$Histology_subtype_2\t$Histology_subtype_3";
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
         my $Primary_site = $f[3];
         my $Site_subtype_1 = $f[4];
         my $Site_subtype_2 = $f[5];
         my $Site_subtype_3 = $f[6];
         my $Primary_histology = $f[7];
         my $Histology_subtype_1 = $f[8];
         my $Histology_subtype_2 = $f[9];
         my $Histology_subtype_3 = $f[10];

         my $output = "$ID_sample\t$ID_tumour\t$mutation_id\t$mutation_pos\t$Primary_site\t$Site_subtype_1\t$Site_subtype_2\t$Site_subtype_3\t$Primary_histology\t$Histology_subtype_1\t$Histology_subtype_2\t$Histology_subtype_3";
         print $O1 "$output\n";
    }

}