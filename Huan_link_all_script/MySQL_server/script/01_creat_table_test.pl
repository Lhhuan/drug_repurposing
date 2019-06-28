#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;


our $database = "OncoRepo";
our $user     = "huan";
our $pw       = "mulinlab_huan";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=202.113.53.211", "$user", "$pw" )
  || die "Could not connect to database: $DBI::errstr";

my $connection = $dbh; 

my @ddl =     (
 # create tags table
 "CREATE TABLE tags (
 tag_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 tag varchar(255) NOT NULL
         ) ENGINE=InnoDB;",
        # create links table
        "CREATE TABLE links (
   link_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
   title varchar(255) NOT NULL,
   url varchar(255) NOT NULL,
   target varchar(45) NOT NULL
 ) ENGINE=InnoDB;",
 # create link_tags table
 "CREATE TABLE link_tags (
   link_id int(11) NOT NULL,
   tag_id int(11) NOT NULL,
   PRIMARY KEY (link_id,tag_id),
   KEY fk_link_idx (link_id),
   KEY fk_tag_idx (tag_id),
   CONSTRAINT fk_tag FOREIGN KEY (tag_id) 
      REFERENCES tags (tag_id),
   CONSTRAINT fk_link FOREIGN KEY (link_id) 
 REFERENCES links (link_id) 
 ) ENGINE=InnoDB"
        );
        