#!/usr/bin/perl
###################################
#Author :Jiang Li
#Email  :riverlee2008@gmail.com
#MSN    :riverlee2008@live.cn
#Address:Harbin Medical University
#TEl    :+86-13936514493
###################################
use strict;
use warnings;

use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=DO.sqlite","","");

my($tablename,$inputdata) = @ARGV;

##########################
#first delete all
my $sql="delete  from ".$tablename;
$dbh->do($sql);


open(IN,$inputdata) or die $!;
my $head=<IN>;
my @a=split "\t",$head;
my $str="INSERT INTO ".$tablename." VALUES (";
foreach (@a){
	$str.="?,";
}
chop($str);
$str.=")";

my $sth = $dbh->prepare($str);

while(<IN>){
	s/\r|\n//g;
	next unless($_);
	@a=split "\t";
	#my($id,$doid,$term,$) = split "\t";
	$sth->execute( @a);
}

 $dbh->disconnect;

