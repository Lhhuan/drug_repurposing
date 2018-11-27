#为ukbb_biobank.txt文件中的sub study提供sample size, 在网页上看到，这些sample都是从uk中招募的。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./ukbb_biobank.txt";
my $f2 ="./ukbb_all_h2part_results.txt";
my $fo1 = "./ukbb_biobank1.txt"; 
#my $fo2 = "./123.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print "$title"; 
# select $O2;
# print "$title"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Phenotype/){
         my $Phenotype_code = $f[0];
         my $Description = $f[1];
         my $File = $f[2];
         my $wget_command = $f[3];
         my $k = "$File\t$Description\t$wget_command";
        push@{$hash1{$Phenotype_code}},$k ;
     }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^phenotype/){
         my $phenotype = $f[0];
         my $sample_size = $f[2];
         $hash2{$phenotype} = $sample_size;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v = @{$hash1{$ID}};
        foreach my $v(@v){
            my @f = split /\t/,$v;
            my $file = $f[0];
            my $trait = $f[1];
            my $wget_command =$f[2];
            print $O1 "$file\t$trait\tUKBB_Biobank\t$s\t$ID\tNA\tEuropean\tEuropean\($s\)|ALL\($s\)\tUKBB_biobank/huan_ukbb_biobank\t$file\t$file\t$wget_command\t\tNA\n";

        }
        
    } 
    else {
        my @v = @{$hash1{$ID}};
        foreach my $v(@v){
            my @f = split /\t/,$v;
            my $file = $f[0];
            my $trait = $f[1];
            my $wget_command =$f[2];
            my $s ="NA";
            print $O1 "$file\t$trait\tUKBB_Biobank\t$s\t$ID\tNA\tEuropean\tEuropean\($s\)|ALL\($s\)\tUKBB_biobank/huan_ukbb_biobank\t$file\t$file\t$wget_command\t\tNA\n";
        }
    }
}



