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

###########################
#use RSQLite to create the DO.sqlite

#my $currentdir=`pwd`;
my $rfile="create_DO.db.R";
open(R,">${rfile}") or die $!;
my $schema="";
while(<DATA>){
	$schema.=$_;
}

my $rstr=<<RDOC;
library(RSQLite)
drv<-dbDriver("SQLite")
dbfile="DO.sqlite"
db <- dbConnect(drv, dbname=dbfile)
schema.text<-'$schema'
create.sql <- strsplit(schema.text, "\\n")[[1]]
create.sql <- paste(collapse="\\n", create.sql)
create.sql <- strsplit(create.sql, ";")[[1]]
create.sql <- create.sql[-length(create.sql)] # nothing to run here
tmp <- sapply(create.sql, function(x) sqliteQuickSQL(db, x))

RDOC

###########################################
#add metadata
my $metadata=<<META;
metadata<-rbind(c("DBSCHEMA","DO_DB"),
		c("DBSCHEMAVERSION","1.0"),
		c("DOSOURCENAME","Disease Ontology"),
		c("DOSOURCURL","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO"),
		c("DOSOURCEDATE","20150323"),
		c("DOVERSION","2806"));
q<-paste(sep="","INSERT INTO 'metadata' VALUES('",metadata[,1],"','",metadata[,2],"');")
tmp<-sapply(q,function(x) sqliteQuickSQL(db,x))		
META

$rstr.=$metadata;


##################################
#add map_metadata
my $map_metadata=<<MAP;
map_metadata<-rbind(c("TERM","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323"),
		    c("OBSOLETE","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323"),
		    c("CHILDREN","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323"),
		    c("PARENTS","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323"),
		    c("ANCESTOR","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323"),
		    c("OFFSPRING","Disease Ontology","http://do-wiki.nubic.northwestern.edu/index.php/Download_DO","20150323")	
);
q<-paste(sep="","INSERT INTO 'map_metadata' VALUES('",map_metadata[,1],"','",map_metadata[,2],"','",map_metadata[,3],"','",map_metadata[,4],"');")
tmp<-sapply(q,function(x) sqliteQuickSQL(db,x))	

MAP

$rstr.=$map_metadata;

##############################
#data for map_counts
my $term_counts=getCounts("do_term.txt");
my $obsolete_counts=getCounts("do_obsolete.txt");
my $children_counts=`sed -n '2,\$p' do_parents.txt |cut -f2|sort|uniq|wc -l |cut -f 1`;
my $parents_counts=`sed -n '2,\$p' do_parents.txt |cut -f1|sort|uniq|wc -l |cut -f 1`;
my $ancestor_counts=`sed -n '2,\$p' do_offspring.txt |cut -f2|sort|uniq|wc -l  |cut -f1`;
my $offspring_counts=`sed -n '2,\$p' do_offspring.txt |cut -f1|sort|uniq|wc -l  |cut -f1`;

my $map_counts=<<MAP;
map_counts<-rbind(c("TERM","$term_counts"),
		c("OBSOLETE","$obsolete_counts"),
		c("CHILDREN","$children_counts"),
		c("PARENTS","$parents_counts"),
		c("ANCESTOR","$ancestor_counts"),
		c("OFFSPRING","$offspring_counts"));
q<-paste(sep="","INSERT INTO 'map_counts' VALUES('",map_counts[,1],"','",map_counts[,2],"');")
tmp<-sapply(q,function(x) sqliteQuickSQL(db,x))			
MAP

$rstr.=$map_counts;

$rstr.="\ndbDisconnect(db)\n";


print R $rstr;

close R;

 `R --no-save < $rfile`;


sub getCounts{
	my($in) = @_;
	my $l=`sed -n '2,\$p' $in |wc -l`;
	my $count=0;
	if($l=~/(\d+)/){
		$count=$1;
	}
	return $count;
}

__DATA__
--
-- DO_DB schema
-- ====================
--
CREATE TABLE do_term (
  _id INTEGER PRIMARY KEY,
  do_id VARCHAR(12) NOT NULL UNIQUE,               -- DI ID
  term VARCHAR(255) NOT NULL                  -- textual label for the DO term
);

CREATE TABLE do_synonym (
  _id INTEGER NOT NULL,                     -- REFERENCES do_term
  synonym VARCHAR(255) NOT NULL,                -- label or DO ID
  secondary VARCHAR(12) NULL,                      -- DO ID
  like_do_id SMALLINT,                          -- boolean (1 or 0)
  FOREIGN KEY (_id) REFERENCES do_term (_id)
);


CREATE TABLE do_parents ( 
  _id INTEGER NOT NULL,                     -- REFERENCES do_term
  _parent_id INTEGER NOT NULL,                   -- REFERENCES do_term
  relationship_type VARCHAR(7) NOT NULL,                 -- type of DO child-parent relationship
  FOREIGN KEY (_id) REFERENCES do_term (_id),
  FOREIGN KEY (_parent_id) REFERENCES do_term (_id)
);

CREATE TABLE do_offspring (
  _id INTEGER NOT NULL,                     -- REFERENCES do_term
  _offspring_id INTEGER NOT NULL,                -- REFERENCES do_term
  FOREIGN KEY (_id) REFERENCES do_term (_id),
  FOREIGN KEY (_offspring_id) REFERENCES do_term (_id)
);


CREATE TABLE do_obsolete (
  do_id VARCHAR(12) PRIMARY KEY,                   -- DO ID
  term VARCHAR(255) NOT NULL                   -- textual label for the DO term
)
;

CREATE TABLE map_counts (
  map_name VARCHAR(80) PRIMARY KEY,
  count INTEGER NOT NULL
);

CREATE TABLE map_metadata (
  map_name VARCHAR(80) NOT NULL,
  source_name VARCHAR(80) NOT NULL,
  source_url VARCHAR(255) NOT NULL,
  source_date VARCHAR(20) NOT NULL
);

CREATE TABLE metadata (
  name VARCHAR(80) PRIMARY KEY,
  value VARCHAR(255)
);

-- Indexes

