#为文件summary_outside_cancer.txt在最后加一列筛选出CAD相关数据，得CAD文件CAD.txt，非CAD，非cancer文件summary_outside_cancer_CAD_revise.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./cad_list_from_k.txt";
my $f2 ="./summary_outside_cancer_revise.txt";
my $fo1 = "./CAD.txt"; #没有do和hpo的文件all_gwas_summary_data
my $fo2 = "./summary_outside_cancer_CAD_revise.txt"; #没有do和hpo的文件all_gwas_summary_data
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tnumber_of_cases\tnumber_of_controls\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\tNormalized_file\n";
select $O1;
print "$title";
select $O2;
print "$title"; 

my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $PMID = $f[5];
    my $file_name= $f[1];
    # my $k = "$file_name\t$PMID";
     unless(/^resources/){
         $hash1{$PMID}=1;
     }

}



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $PMID = $f[6];
    my $file_name= $f[0];
    # my $k = "$file_name\t$PMID";
     unless(/^File_name/){
         push @{$hash2{$PMID}},$_
     }
}



foreach my $pmid (sort keys %hash2){
    if(exists $hash1{$pmid}){
        my @alls= @{$hash2{$pmid}};
        foreach my $all(@alls){
            print $O1 "$all\n";
        }
    }
    else{
         my @alls= @{$hash2{$pmid}};
        foreach my $all(@alls){
            print $O2 "$all\n";
        }       
    }
}