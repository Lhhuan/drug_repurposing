#!/usr/bin/perl

use warnings;
use strict;

my $fi_drug_targetid_name ="./step3_mismatch_targetid_indication_drug_mimnumber_disorder_uniprotid";
my $fi_targetid_name ="./TTDtargrtid-targetname";



open my $fh_drug_targetid_name, '<', $fi_drug_targetid_name or die "$0 : failed to open input file '$fi_drug_targetid_name' : $!\n";
open my $fh_targetid_name, '<', $fi_targetid_name or die "$0 : failed to open input file '$fi_targetid_name' : $!\n";


my %tid;
my %ttn;

while(<$fh_drug_targetid_name>)
{
    chomp;
    
        my @f1 = split /\t/;
        my $targetid = $f1[0];
        my $data1 = join "\t", @f1[1,2,3,4,5];
        push @{$tid{$targetid}},$data1;
        
    
}

while(<$fh_targetid_name>)
{
    

        my @f2 = split /\t/;
        my $id = $f2[0];
        my $name = $f2[1];
        $ttn{$id}=$name;
        print $id."\t".$name."\n";
    
}

# foreach my $id (sort keys %ttn){
#      if( exists $tid{$id}){
#             my @data = @{$tid{$id}};
#             my $targetname = $ttn{$id};
#           #  print $id."\t".$targetname."\n";
#         foreach my $data(@data){
#                print $data."\t". $id."\n";
#             # print $id."\t".$targetname."\t".$data."\n";
#             #print $data."\n";
            
#         }
#     }

# }






