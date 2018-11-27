#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $file_conf = $ARGV[0] ? $ARGV[0] : "rsync_data.conf";
open my $IC, '<', $file_conf
  or die "$0 : failed to open input file '$file_conf' : $!\n";
my @confs = <$IC>;
close $IC or warn "$0 : failed to close input file '$file_conf' : $!\n";

my ( $ref_srcs, $ref_dests, $ref_size, $ref_includes, $ref_excludes ) =
  parse_conf(@confs);
my @srcs     = @{$ref_srcs};
my @dests    = @{$ref_dests};
my $size     = ${$ref_size};
my @includes = @{$ref_includes};
my @excludes = @{$ref_excludes};

&check_conf();
&rm_null();
&rsync_small();
&touch_big();

sub parse_conf {
    my @confs = @_;
    foreach my $conf (@confs) {
        $conf =~ s/^\s+//;
        $conf =~ s/\s+=\s+/=/;
        $conf =~ s/\s+$//;
        if ( $conf =~ /^from=(.+)$/ ) {
            @srcs = split /,/, $1;
        }
        if ( $conf =~ /^to=(.+)$/ ) {
            @dests = split /,/, $1;
        }
        if ( $conf =~ /^size=(.+)$/ ) {
            $size = $1;
        }
        if ( $conf =~ /^include=(.+)$/ ) {
            @includes = split /,/, $1;
        }
        if ( $conf =~ /^exclude=(.+)$/ ) {
            @excludes = split /,/, $1;
        }
    }
    return ( \@srcs, \@dests, \$size, \@includes, \@excludes );
}

sub check_conf {
    print STDERR "### Check configures in the conf file ...\n";
    if ( scalar(@srcs) != scalar(@dests) ) {
        die "One source, one destination!\n";
    }
    foreach my $dest (@dests) {
        -d $dest or die "Destination ($dest) must be exist!\n";
    }
}

sub rm_null {
    print STDERR "### Remove *.NULL files in the destinations ...\n";
    foreach my $dest (@dests) {
        system "find $dest -name \"*.NULL\" -exec rm {} +";
    }
}

sub rsync_small {
    print STDERR "### rsync small files ...\n";
    my $cmd_rsync = "rsync -a -z --delete -progress --stats -h -v ";
    $cmd_rsync .= "--max-size=\"$size\" ";
    foreach my $include (@includes) {
        $cmd_rsync .= "--include=\"$include\" ";
    }
    foreach my $exclude (@excludes) {
        $cmd_rsync .= "--exclude=\"$exclude\" ";
    }
    $cmd_rsync .= "-e ssh ";
    for ( my $i = 0 ; $i <= $#srcs ; $i++ ) {
        print STDERR "####$srcs[$i] ===>>> $dests[$i]####\n";
        my $rsync = $cmd_rsync . "$srcs[$i]/ $dests[$i]";
        system "$rsync";
    }
}

sub touch_big {
    print STDERR "### Touch big file as *.NULL in the destination ...\n";
    my $cmd_rsync = "rsync -a -z -i --dry-run ";
    $cmd_rsync .= "--min-size=\"$size\" ";
    foreach my $include (@includes) {
        $cmd_rsync .= "--include=\"$include\" ";
    }
    foreach my $exclude (@excludes) {
        $cmd_rsync .= "--exclude=\"$exclude\" ";
    }
    $cmd_rsync .= "-e ssh ";
    for ( my $i = 0 ; $i <= $#srcs ; $i++ ) {
        print STDERR "####$srcs[$i] ===>>> $dests[$i]####\n";
        my $rsync     = $cmd_rsync . "$srcs[$i]/ $dests[$i]";
        my $lines_big = `$rsync`;
        my @lines     = split /\n/, $lines_big;
        foreach my $line (@lines) {
            if ( $line =~ /^>f.+?\s+(.+?)$/ ) {
                my $file = "$dests[$i]/$1";
                if ( -e $file ) {
                    system "rm \"$file\"";
                }
                system "touch \"${file}.NULL\"";
            }
        }
    }
}

