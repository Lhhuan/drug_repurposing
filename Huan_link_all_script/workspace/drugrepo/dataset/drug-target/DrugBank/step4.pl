#将entre_id和ensg-id进行转换。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step2_result_gene_drug.txt";
my $fi1  ="./transform.txt";
my $fo = "./step4_drugbank_drug_gene_entrez_id.txt";
my $fo1 = "./step4_unmatch_ensg.txt";
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $I1, '<', $fi1 or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O;
print "entrez_id\tensg_id\tENSTID\tUniprot_ID\tDRUG_NAME\tcas_number\ttarget_name\taction_text\tdrug_type\tbest_level\tindication\tside_effect\tcancer_prescribed\ttumor_type\tsource_id\tsource\tsource_database\tchemle_id\n";
select $O1;
print "ensg_id\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I>)
{
   chomp;
   unless(/^ENSGID/){
       my @f = split/\t/;
       my $ensg_id = $f[0];
       my $t = join "\t", @f[1..16];
       push @{$hash1{$ensg_id}},$t; 

   }
}

while(<$I1>)
{
   chomp;
   unless(/^query/){
       my @f = split/\t/;
       my $ensg_id = $f[0];
       my $entrez_id = $f[3];
       $hash2{$ensg_id} = $entrez_id; 

   }
}

foreach my $ensg_id (sort keys %hash1){
    if (exists $hash2{$ensg_id}){
        my @t = @{$hash1{$ensg_id}};
        my $entrez_id = $hash2{$ensg_id};
        foreach my $t(@t){
            my $k3 = "$entrez_id\t$ensg_id\t$t";
            unless(exists $hash3{$k3}){
                    print $O "$k3\n";
                    $hash3{$k3} = 1; 
            }
        }
    }
    else{ 
        my $k4 = $ensg_id;
        unless(exists $hash4{$k4}){
            print $O1 "$k4\n";
            $hash4{$k4} = 1;
        }
        my @t = @{$hash1{$ensg_id}};
        foreach my $t(@t){
            my $k3 = "NA\t$ensg_id\t$t";
            unless(exists $hash3{$k3}){
                    print $O "$k3\n";
                    $hash3{$k3} = 1; 
            }
        }
    }
}
