#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

#mysql config cariables
our $database = "OncoRepo";
our $user     = "huan";
our $pw       = "mulinlab_huan";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=202.113.53.211", "$user", "$pw" )  #连接数据库
  || die "Could not connect to database: $DBI::errstr";

##connect to mysql 
# my $connection = $dbh;

# my $dir = "/f/mulinlab/zhanye/project/QTLdb/data_refgene";
my %hash1;
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    for (my $i=0;$i<6;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NA";
        }
        unless($f[$i]=~/\w/){$f[$i]="NA"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Gene_symbol =$f[1];
        $Gene_symbol =~s/NULL|NONE/NA/g;
        my $Entrez_id =$f[2];
        $Entrez_id =~s/NULL|NONE/NA/g;
        my $Interaction_types =$f[3];
        $Interaction_types =uc($Interaction_types);
        $Interaction_types =~s/NULL|NONE/NA/g;
        my $ENSG_ID =$f[14];
        $ENSG_ID =~s/NULL|NONE/NA/g;
        my $Final_source =$f[15];
        # my $Indication_ID = $f[16];
        my $Drug_type = $f[17];
        # my $indication_OncoTree_term_detail =$f[22];
        # my $indication_OncoTree_IDs_detail =$f[23];
        # my $indication_OncoTree_main_term =$f[24];
        # my $indication_OncoTree_main_ID =$f[25];
        my $drug_target_score =$f[26];
        my $PACTIVITY_median = $f[27];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id\t$ENSG_ID\t$Interaction_types\t$Drug_type\t$Final_source\t$drug_target_score\t$PACTIVITY_median";
        # print "$k\n";
        unless(exists $hash1{$k}){ #去重
            $hash1{$k} =1;
            if ($Gene_symbol eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Gene_symbol) 
            }
            if ($Entrez_id eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Entrez_id) 
            }
            if ($Interaction_types eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Interaction_types)
            }
            if ($ENSG_ID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($ENSG_ID) 
            }
            if ($drug_target_score eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($drug_target_score) 
            }
            if ($PACTIVITY_median eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($PACTIVITY_median) 
            }
            $sth = $dbh -> prepare("insert into Drug_target_information (Unique_drug_name,Gene_symbol,Entrez_id,ENSG_ID,
            Interaction_types,Drug_type,Final_source,Drug_target_score,Drug_target_PACTIVITY_median) 
                                    values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($Drug_chembl_id_Drug_claim_primary_name,$Gene_symbol,$Entrez_id,$ENSG_ID,$Interaction_types,$Drug_type,$Final_source,$drug_target_score,$PACTIVITY_median); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
