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
        my $Max_phase =$f[6];
        my $First_approval =$f[7];
        $First_approval =~ s/\\N/HA/g;
        $First_approval =~ s/NULL/NA/g;
        my $Indication_class =$f[8];
        $Indication_class =~s/"//g;
        my $Drug_indication =$f[9];
        $Drug_indication =~ s/"//g;
        $Drug_indication =~s/NULL|NONE|null|none/NA/;
        my $Drug_indication_source = $f[10];
        $Drug_indication_source =~ s/NULL|NONE/NA/g;
        my $Clinical_phase =$f[11];
        $Clinical_phase =~ s/N\/A/NA/g;
        my $Link_Refs = $f[12];
        $Link_Refs =~ s/NULL|NONE/NA/g;
        my $Drug_indication_Indication_class =$f[13];
        $Drug_indication_Indication_class =~ s/NULL|NONE/NA/g;
        # my $ENSG_ID =$f[14];
        my $Indication_ID = $f[16];
        # my $Drug_type = $f[17];
        # my $indication_OncoTree_term_detail =$f[22];
        # my $indication_OncoTree_IDs_detail =$f[23];
        # my $indication_OncoTree_main_term =$f[24];
        # my $indication_OncoTree_main_ID =$f[25];
        # my $drug_target_score =$f[26];
        # my $PACTIVITY_median = $f[27];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Max_phase\t$First_approval\t$Link_Refs\t$Indication_class";
        $k= "$k\t$Drug_indication\t$Drug_indication_Indication_class\t$Indication_ID\t$Drug_indication_source";
        # print "$k\n";
        unless(exists $hash1{$k}){ #去重
            $hash1{$k} =1;
            if ($Max_phase eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Max_phase) 
            }
            if ($First_approval eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($First_approval) 
            }
            if ($Link_Refs eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Link_Refs)
            }
            if ($Indication_class eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Indication_class) 
            }
            if ($Drug_indication eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Drug_indication) 
            }
            if ($Drug_indication_Indication_class eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Drug_indication_Indication_class) 
            }
            if ($Drug_indication_source eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Drug_indication_source) 
            }
            $sth = $dbh -> prepare("insert into Drug_indication (Unique_drug_name,Max_phase,First_approval,Indication_class,
            Drug_indication,Drug_indication_Indication_class,Indication_ID,Drug_indication_source) 
                                    values (?, ?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($Drug_chembl_id_Drug_claim_primary_name,$Max_phase,$First_approval,$Indication_class,$Drug_indication,$Drug_indication_Indication_class,$Indication_ID,$Drug_indication_source); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
