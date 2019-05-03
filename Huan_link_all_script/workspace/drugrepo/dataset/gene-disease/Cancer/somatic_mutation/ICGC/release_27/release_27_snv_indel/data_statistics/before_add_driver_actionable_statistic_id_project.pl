#统计每个mutation id对应的project，统计affected donor >1的id 和Project 得文件before_add_driver_actionable_mutation_ID_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../simple_somatic_mutation.largethan1.vcf";
my $fo1 = "./before_add_driver_actionable_mutation_ID_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "ID\tproject\tcancer_specific_affected_donors\n";
while(<$I1>)
{
    chomp;
    unless (/^#/){
        my @f = split/\s+/;
        my $ID = $f[2];
        my $info = $f[7];
        #print STDERR "$ID\n";
        my @info_array = split/\;/,$info;
        foreach my $i(@info_array){
            if ($i=~/^OCCURRENCE/){
                #print STDERR "$i\n";
                my @occur_info = split/\=/,$i;
                my $occurs= $occur_info[1];
                my @cancer_info =  split/\,/,$occurs;
                foreach my $cancers(@cancer_info){
                    my @cancer = split/\|/,$cancers;
                    my $final_cancer = $cancer[0];
                    my $cancer_specific_affected_donors = $cancer[1];
                    if ($cancer_specific_affected_donors>1){
                        print $O1 "$ID\t$final_cancer\t$cancer_specific_affected_donors\n";
                    }
                }

            }

        }
       
     }
}
