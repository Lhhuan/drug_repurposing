#填写部分的GWAS_Catalog_summary_statistic.txt数据
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./GWAS_Catalog_statistic.txt";
my $fo1 = "./GWAS_Catalog_summary_statistic.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait_name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file(file_name/website)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print $title;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Author/){
         my $A= $f[0];
         my @p = split/\s\(/,$A;
         my $author = $p[0];
         $author =~ s/\s+/_/g;
         #$author =~ s/\$_//g;
         my $pmid = $p[1];
         $pmid =~ s/PMID\:\s+//g;
         $pmid =~ s/\)//g;
         my $data = $f[1];
         my @pub= split /\//,$data;
         my $Publish_year = $pub[0];
         my $Trait_name = $f[4];
         $Trait_name =~ s/\s+/_/g;
         $Trait_name =~ s/\//_or_/g;
         my $File_ID_local = $pmid."_".$Trait_name."."."txt";
         my $Folder_name_local = $pmid;
         #my $output = "na\t$Trait_name\t$Consortium\t$Sample_size\t$PMID\t$Publish_year\t$Ethnicity\tna\t$Folder_name_local\tna\t$File_ID_local\t$Documentation_file\tna\tna\tna\tna\tna\t";
         my $output = "\t$Trait_name\t$author\t\t$pmid\t$Publish_year\t\t\t$Folder_name_local\t\t$File_ID_local\t\t\t\t\t\t\t";
         print $O1 "$output\n";
    }
}
          