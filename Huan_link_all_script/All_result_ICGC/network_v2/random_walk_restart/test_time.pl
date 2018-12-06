#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Time::HiRes qw(gettimeofday) ;

my ($start_sec, $start_usec) = gettimeofday;
system "python run_walker.py original_network_num.txt huan_data_rwr/start/omega_interferon.txt > test_time.txt";
my($end_sec, $end_usec) = gettimeofday;
my $timeDelta = ($end_usec - $start_usec) / 1000 + ($end_sec - $start_sec) * 1000;
print STDERR "$timeDelta\n";