#填写部分的LD_hub_gwas_summary_statistic.txt数据
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./LD-Hub_study_information_and_SNP_heritability.txt";
my $fo1 = "./LD_hub_gwas_summary_statistic.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait_name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file(file_name/website)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";

select $O1;
print $title;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Filename/){
         my $Trait_name = $f[2];
         my $Consortium = $f[3];
         my $Sample_size = $f[7];
         my $PMID = $f[9];
         my $Publish_year = $f[12];
         my $Ethnicity = $f[4];
         my $Folder_name_local = $PMID;
         my $trait = $Trait_name;
         $trait =~ s/\s+/_/g;
         my $File_ID_local = $PMID."_".$trait."."."txt";
         my $Documentation_file = $f[1];
         #my $output = "na\t$Trait_name\t$Consortium\t$Sample_size\t$PMID\t$Publish_year\t$Ethnicity\tna\t$Folder_name_local\tna\t$File_ID_local\t$Documentation_file\tna\tna\tna\tna\tna\t";
         my $output = "\t$Trait_name\t$Consortium\t$Sample_size\t$PMID\t$Publish_year\t$Ethnicity\t\t$Folder_name_local\t\t$File_ID_local\t$Documentation_file\t\t\t\t\t\t";
         print "$output\n";
     }
}
          
