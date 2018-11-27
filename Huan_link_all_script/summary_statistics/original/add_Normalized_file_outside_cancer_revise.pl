#为文件summary_outside_cancer.txt在最后加一列Normalized_file，得文件summary_outside_cancer_revise.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./summary_outside_cancer.txt";
my $fo1 = "./summary_outside_cancer_revise.txt"; #没有do和hpo的文件all_gwas_summary_data
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tnumber_of_cases\tnumber_of_controls\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\tNormalized_file\n";
select $O1;
print "$title"; 

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $File_ID_local = $f[12];
     unless(/^File_name/){
         if ($File_ID_local=~/txt/){
             unless($File_ID_local=~/ukbb/){
                 $File_ID_local=~ s/.txt/_normalized.txt/g;
                 $File_ID_local=~s/"//g;
                 my $Normalized_file = $File_ID_local;
                 print $O1 "$_\t$Normalized_file\n";
                 
             }
         }
         elsif($File_ID_local=~/assoc.tsv.gz/){
             $File_ID_local=~s/.tsv.gz/.normalized.txt/g;
             my $Normalized_file = $File_ID_local;

             print $O1 "$_\t$Normalized_file\n";
         }
         else{
             print $O1 "$_\t\n";
         }
     }

}

