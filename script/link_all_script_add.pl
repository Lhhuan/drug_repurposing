#!/usr/bin/perl
use warnings;
use strict;
use utf8;
use File::Basename;

my $dir_out   = "/f/mulinlab/huan/Script_backup/Huan_link_all_script";
mkdir $dir_out unless -d $dir_out;

chdir "/f/mulinlab/huan/";
system "find -name *.pl > /f/mulinlab/huan/perl_script";
system "find -name *.R > /f/mulinlab/huan/R_script";
system "find -name *.sh > /f/mulinlab/huan/all_sh_script";
system "find -name *.py > /f/mulinlab/huan/python_script";
system "find -name *readme.txt > /f/mulinlab/huan/readme";

my $f1 ="/f/mulinlab/huan/perl_script";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
while(<$I1>)
{
    chomp;
    my $script = $_;
    unless($script=~/^\.\/anaconda/){
        unless($script=~/^\.\/Script_backup/){
            unless($script=~/^\.\/php/){
                my $file = basename($script);
                my $dir = dirname($script);
                $dir=~s/^\.\///;
                my $do = "$dir_out/$dir";
                # mkdir  $do unless -d $do;
                unless(-e $do ){
                    system "mkdir -p $do";
                }
                my $new_file ="$do/$file";
                unless(-e "$new_file"){
                    #print "#$new_file\n";
                    my $link1 = "ln \"$script\" \"$new_file\"" ;  #把变量引起来，这样就可以将名为12 3.pl的脚本copy 过来。而不会只copy12 而不copy 12 3.pl
                   system "$link1\n";
                    # print "$link1\n";
                }
            }
        }
    }
}

my $f2 ="/f/mulinlab/huan/R_script";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
while(<$I2>)
{
    chomp;
    my $script = $_;
    unless($script=~/^\.\/anaconda/){
        unless($script=~/^\.\/Script_backup/){
            unless($script=~/^\.\/php/){
                my $file = basename($script);
                my $dir = dirname($script);
                $dir=~s/^\.\///;
                my $do = "$dir_out/$dir";
                # mkdir  $do unless -d $do;
                unless(-e $do ){
                    system "mkdir -p $do";
                }
                my $new_file ="$do/$file";
                unless(-e "$new_file"){
                    #print "#$new_file\n";
                    my $link1 = "ln \"$script\" \"$new_file\"" ;  #把变量引起来，这样就可以将名为12 3.pl的脚本copy 过来。而不会只copy12 而不copy 12 3.pl
                   system "$link1\n";
                    # print "$link1\n";
                }
            }
        }
    }
}

my $f3 ="/f/mulinlab/huan/all_sh_script";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
while(<$I3>)
{
    chomp;
    my $script = $_;
    unless($script=~/^\.\/anaconda/){
        unless($script=~/^\.\/Script_backup/){
            unless($script=~/^\.\/php/){
                my $file = basename($script);
                my $dir = dirname($script);
                $dir=~s/^\.\///;
                my $do = "$dir_out/$dir";
                # mkdir  $do unless -d $do;
                unless(-e $do ){
                    system "mkdir -p $do";
                }
                my $new_file ="$do/$file";
                unless(-e "$new_file"){
                    #print "#$new_file\n";
                    my $link1 = "ln \"$script\" \"$new_file\"" ;  #把变量引起来，这样就可以将名为12 3.pl的脚本copy 过来。而不会只copy12 而不copy 12 3.pl
                   system "$link1\n";
                    # print "$link1\n";
                }
            }
        }
    }
}

my $f4 ="/f/mulinlab/huan/readme";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
while(<$I4>)
{
    chomp;
    my $script = $_;
    unless($script=~/^\.\/anaconda/){
        unless($script=~/^\.\/Script_backup/){
            unless($script=~/^\.\/php/){
                my $file = basename($script);
                my $dir = dirname($script);
                $dir=~s/^\.\///;
                my $do = "$dir_out/$dir";
                # mkdir  $do unless -d $do;
                unless(-e $do ){
                    system "mkdir -p $do";
                }
                my $new_file ="$do/$file";
                unless(-e "$new_file"){
                    #print "#$new_file\n";
                    my $link1 = "ln \"$script\" \"$new_file\"" ;  #把变量引起来，这样就可以将名为12 3.pl的脚本copy 过来。而不会只copy12 而不copy 12 3.pl
                   system "$link1\n";
                    # print "$link1\n";
                }
            }
        }
    }
}

my $f5 ="/f/mulinlab/huan/python_script";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
while(<$I5>)
{
    chomp;
    my $script = $_;
    unless($script=~/^\.\/anaconda/){
        unless($script=~/^\.\/Script_backup/){
            unless($script=~/^\.\/php/){
                my $file = basename($script);
                my $dir = dirname($script);
                $dir=~s/^\.\///;
                my $do = "$dir_out/$dir";
                # mkdir  $do unless -d $do;
                unless(-e $do ){
                    system "mkdir -p $do";
                }
                my $new_file ="$do/$file";
                unless(-e "$new_file"){
                    #print "#$new_file\n";
                    my $link1 = "ln \"$script\" \"$new_file\"" ;  #把变量引起来，这样就可以将名为12 3.pl的脚本copy 过来。而不会只copy12 而不copy 12 3.pl
                   system "$link1\n";
                    # print "$link1\n";
                }
            }
        }
    }
}
