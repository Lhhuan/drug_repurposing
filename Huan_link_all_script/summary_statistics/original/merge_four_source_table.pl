#筛选出ukbb_biobank1.txt中女性生殖系统疾病
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./GRASP/GRASP_mannual_fill.txt";
my $f2 ="./GWAS_Catalog/GWAS_Catalog_summary_no_woman_sential_system.txt"; 
my $f3 ="./LD_hub/LD_hub_gwas_summary_statistic_mannual_fill_v2.txt"; 
my $f4 ="./UKBB_biobank/ukbb_biobank1_no_woman_sential_system.txt"; 
my $fo1 = "./all_gwas_summary_v1.txt"; #没有do和hpo的文件all_gwas_summary_data
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print "$title"; 

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $Folder_name_local = $f[8];
     unless(/^File_name/){
         $f[8] = "GRASP/$f[8]";
         my $k = join("\t",@f[0..13]);
         print $O1 "$k\n";
     }

}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $Folder_name_local = $f[8];
     unless(/^File_name/){
         $f[8] = "GWAS_Catalog/$f[8]";
         my $k = join("\t",@f[0..13]);
         print $O1 "$k\n";
     }

}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $Folder_name_local = $f[8];
     unless(/^File_name/){
         $f[8] = "LD_hub/$f[8]";
         my $k = join("\t",@f[0..13]);
         print $O1 "$k\n";
     }

}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    my $Folder_name_local = $f[8];
     unless(/^File_name/){
         #$f[8] = "UKBB_biobank/$f[8]";
         my $k = join("\t",@f[0..13]);
         print $O1 "$k\n";
     }

}
