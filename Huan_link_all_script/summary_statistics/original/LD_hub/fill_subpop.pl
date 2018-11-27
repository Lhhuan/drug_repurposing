#筛选出ukbb_biobank1.txt中女性生殖系统疾病
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./LD_hub_gwas_summary_statistic_mannual_fill.txt";
my $fo1 = "./LD_hub_gwas_summary_statistic_mannual_fill_v2.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print "$title"; 
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^File_name/){
         my $Sample_size = $f[3];
         my $Ethnicity = $f[6];
         my $Sub_population =$f[7];
         if ($Ethnicity !~/Mixed/){
            $Sub_population = "$Ethnicity($Sample_size)|ALL($Sample_size)";
            my $k = join("\t",@f[0..6],$Sub_population,@f[8..13]);
            print "$k\n";
         }
         else{
             print "$_\n";
         }
     }

}