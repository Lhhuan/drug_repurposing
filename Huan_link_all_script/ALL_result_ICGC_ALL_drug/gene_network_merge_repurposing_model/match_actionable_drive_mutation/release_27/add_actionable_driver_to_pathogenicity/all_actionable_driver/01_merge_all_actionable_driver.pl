#将../in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt 和../out_ICGC/output/01_unique_all_driver_actionable_out_ICGC.txt merge 到一起，
#其中不在../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt 中 的mutation 是新加的，
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/out_icgc_add_cgi.txt" #是新加的,包括未经筛选的mutation(比如没有cancer的)
#得./output/01_all_actionable_driver_mutation.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt";
my $f2 = "../in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt";
my $f3 = "../out_ICGC/output/01_unique_all_driver_actionable_out_ICGC.txt";
my $f4 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/cgi_oncogenic_mutation/output/out_icgc_add_cgi.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
my $fo1 = "./output/01_all_actionable_driver_mutation.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Mutation_id\tType\tSource\n";


my (%hash1,%hash2,%hash3);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    # print $O1 "$_\tin_ICGC_P\n";
    unless(/^ICGC_Mutation_ID/){
        my $mutation_id = $f[0];
        my $source = $f[1];
        if($mutation_id =~/Add/){ #第一次加的out icgc
                push @{$hash3{$mutation_id}},$source;
        }
        else{
            print $O1 "$_\tin_ICGC_P\n"; 
        }
        $hash1{$mutation_id}=1;

    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^ICGC_Mutation_ID/){
        my $mutation_id = $f[0];
        my $type = $f[1];
       unless (exists $hash1{$mutation_id}){ #在除去第一版加的pathogenicity中
            print $O1 "$_\tin_ICGC\n";
        }
    }
}


while(<$I3>) #第一次和第二次不在icgc中的，这部分数据有些重复，在第一次认为不在icgc中，在第一次加完之后，在第二次判断时，部分是认为在p中，即和../in_ICGC/output/02_unique_all_driver_actionable_in_pathogenicity_ICGC.txt有重复，lable为ADD
{
    chomp;
    my @f= split/\t/;
    unless(/^hgvsg/){
        my $hgvsg = $f[0];
        my $type = $f[1];
        my $variant_id = "Add"."$hgvsg";
        if (exists $hash3{$variant_id}){
            push @{$hash3{$variant_id}},$type;
        }
        else{
            print $O1 "$variant_id\t$type\tADD\n";
        }
    }
}

while(<$I4>)
{
    chomp;
    my @f= split/\t/;
    my $hgvsg = $f[0];
    unless($hgvsg =~/__/){
        my $type = "cgi_oncogenic_mutation";
        my $variant_id = "Add"."$hgvsg";
        my $output = "$variant_id\t$type\tADD";
        unless (exists $hash2{$output}){
            $hash2{$output} =1;
            print $O1 "$output\n";
        }
    }
   
}

foreach my $id(sort keys %hash3){
    my @sources  = @{$hash3{$id}};
    my %hash4;
    @sources = grep { ++$hash4{$_}<2} @sources;
    my $source =join(";",@sources);
    print $O1 "$id\t$source\tADD\n";

}