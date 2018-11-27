#填写部分的GWAS_Catalog_summary_statistic.txt数据
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

#my $f1 ="./GWAS_Catalog_summary_statistic_manual_full.txt";
my $f1 ="./LD_hub_gwas_summary_statistic_mannual_fill.txt";
my $f2 ="./gwascatalog.txt";
#my $fo1 = "./GWAS_Catalog_summary_statistic_manual_full1.txt";
my $fo1 = "./LD_hub_gwas_summary_statistic_manual_full1.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#my $title = "File_name_Downloaded\tTrait_name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file(file_name/website)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
my $title = "PMID\tTrait_name\tSUB_POPULATION\tSample_size\tDO_ID\tDO_TERM\tHPO_ID\tHPO_TERM\n";
select $O1;
print $title;
my (%hash1,%hash2,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^File_name_Downloaded/){
         my $Trait_name = $f[1];
         my $pmid = $f[4];
         push@{$hash1{$pmid}},$Trait_name;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^CHR/){
         for (my $i=0;$i<20;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
         }
         my $pmid = $f[6];
         my $SUB_POPULATION = $f[12];
         my $sample_size = $SUB_POPULATION ;
         my @p = split /\|/,$sample_size;
         my $sz = $p[-1];
         $sz =~ s/ALL\(//g;
         $sz =~ s/\,//;
         $sz=~ s/\(//g;
         $sz =~ s/\)//g;
         $sz =~ s/\"//g;

         #$sz =~ s/\*ALL\(//g;
         #$sample_size =~ s/\)//g;
         #print STDERR "$sz\n";
         #EUR(6395）|ALL(6395)
         my $GWAS_TRAIT = $f[15];
         my $HPO_ID = $f[16];
         my $HPO_TERM = $f[17];
         my $DO_ID = $f[18];
         my $DO_TERM = $f[19];
         my $k = "$GWAS_TRAIT\t$SUB_POPULATION\t$sz\t$DO_ID\t$DO_TERM\t$HPO_ID\t$HPO_TERM";
         push@{$hash2{$pmid}},$k;
    }
}

foreach my $pmid(sort keys %hash1){
       if(exists $hash2{$pmid}){
            my @v1 = @{$hash1{$pmid}};
            my @v2 = @{$hash2{$pmid}};
             foreach my $v1(@v1){
                foreach my $v2(@v2){
                    my @f = split/\t/,$v2;
                    if($v1 eq $f[0]){
                        my $k4 = "$pmid\t$v1\t$v2";
                        unless(exists $hash4{$k4}){
                            print $O1 "$k4\n";
                            $hash4{$k4} = 1;
                         }
                    }   
                }
             }
        }
        
        else{
            my @v1 = @{$hash1{$pmid}}; 
            foreach my $v1(@v1){
                print $O1 "$pmid\t$v1\n";
            }
        }
}                   