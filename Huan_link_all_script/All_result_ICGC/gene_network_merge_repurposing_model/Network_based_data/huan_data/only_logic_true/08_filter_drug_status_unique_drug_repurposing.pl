#因为./output/07_indication_and_cancer_differ_info.txt中同一个drug有不同status，
#对于有多个status的药物，取最大的status得./output/08_final_network_based_drug_repurposing_success.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./output/07_indication_and_cancer_differ_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/08_final_network_based_drug_repurposing_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";



my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\n";
    }
    else{
        my $k =join("\t",@f[0..14]);
        my $Max_phase = $f[15];
        my $First_approval = $f[16];
        my $v = "$Max_phase\t$First_approval";
        push @{$hash1{$k}},$v;
    }
}

foreach my $drug_info(sort keys %hash1){
    my @status_infos = @{$hash1{$drug_info}};
    my $num = @status_infos;
    if ($num eq 1){
        my $output ="$drug_info\t$status_infos[0]";
        unless (exists $hash2{$output}){
            $hash2{$output} =1;
            print $O1 "$output\n";
        }
    }
    else{   #在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched
        foreach my $status_info(@status_infos){
            unless($status_info =~/^unknown/){
                if ($status_info =~/^Launched/){ #最大是launched
                    $hash3{$drug_info}=1;
                    my $output ="$drug_info\t$status_info";
                    unless (exists $hash2{$output}){
                        $hash2{$output} =1;
                        print $O1 "$output\n";
                    }                                                                                                             
                }
                else{
                    unless(exists $hash3{$drug_info}){
                        if ($status_info =~/^4/){#最大是phase4
                            $hash3{$drug_info}=1;
                            my $output ="$drug_info\t$status_info";
                            unless (exists $hash2{$output}){
                                $hash2{$output} =1;
                                print $O1 "$output\n";
                            }                                                                                                             
                        }
                        else{
                            unless(exists $hash3{$drug_info}){
                                if ($status_info =~/^3/){#最大是phase3
                                    $hash3{$drug_info}=1;
                                    my $output ="$drug_info\t$status_info";
                                    unless (exists $hash2{$output}){
                                        $hash2{$output} =1;
                                        print $O1 "$output\n";
                                    }                                                                                                             
                                }
                                else{
                                    unless(exists $hash3{$drug_info}){
                                       if ($status_info =~/^2/){#最大是phase2
                                            $hash3{$drug_info}=1;
                                            my $output ="$drug_info\t$status_info";
                                            unless (exists $hash2{$output}){
                                                $hash2{$output} =1;
                                                print $O1 "$output\n";
                                            }                                                                                                             
                                        }
                                        else{
                                            unless(exists $hash3{$drug_info}){
                                                if ($status_info =~/^1/){#最大是phase1
                                                    $hash3{$drug_info}=1;
                                                    my $output ="$drug_info\t$status_info";
                                                    unless (exists $hash2{$output}){
                                                        $hash2{$output} =1;
                                                        print $O1 "$output\n";
                                                    }                                                                                                             
                                                }
                                                else{
                                                    unless(exists $hash3{$drug_info}){
                                                        if ($status_info =~/^0/){#最大是phase0
                                                            $hash3{$drug_info}=1;
                                                            my $output ="$drug_info\t$status_info";
                                                            unless (exists $hash2{$output}){
                                                                $hash2{$output} =1;
                                                                print $O1 "$output\n";
                                                            }                                                                                                             
                                                        }
                                                        else{
                                                            unless(exists $hash3{$drug_info}){
                                                                if ($status_info =~/^Preclinical/){#最大是phase0
                                                                    $hash3{$drug_info}=1;
                                                                    my $output ="$drug_info\t$status_info";
                                                                    unless (exists $hash2{$output}){
                                                                        $hash2{$output} =1;
                                                                        print $O1 "$output\n";
                                                                    }                                                                                                             
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}