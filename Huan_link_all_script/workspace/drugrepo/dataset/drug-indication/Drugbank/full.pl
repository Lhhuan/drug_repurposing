#!/usr/bin/perl

# use module
use XML::Simple;
use Data::Dumper;

$xml = XMLin('full database.xml');
print Dumper($xml);