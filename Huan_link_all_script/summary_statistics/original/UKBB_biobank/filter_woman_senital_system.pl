#筛选出ukbb_biobank1.txt中女性生殖系统疾病
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./ukbb_biobank1.txt";
my $fo1 = "./ukbb_biobank1_woman_sential_system.txt"; 
my $fo2 = "./ukbb_biobank1_no_woman_sential_system.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print "$title"; 
select $O2;
print "$title"; 
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^File_name/){
         my $Trait_name = $f[1];
         $Trait_name = lc($Trait_name);
         if ($Trait_name=~/ovary|cervix|vagina|vagino|fallopain|ovarian|uterine/){
             print $O1 "$_\n";

         }
         else{
             print $O2 "$_\n";

         }
     }

}