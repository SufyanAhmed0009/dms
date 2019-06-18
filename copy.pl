#!/usr/bin/perl
 
use warnings;
#use strict;
 
use File::Copy;
#my $srcdir = "/root/Tamoor/Scripts/folder1/";
#my $dest = "/root/Tamoor/Scripts/folder2/"; 

my $srcdir = "copy1";
my $dest = "copy2";
 
#my $srcdir = "C:/Users/sufya/Desktop/New folder/folder2";
#my $dest = "C:/Users/sufya/Desktop/New folder/folder1";
 
for (;;) { 
    opendir(DIR, $srcdir) or die "Can't open $srcdir: $!";
#     @files = grep {!/^\.+$/} readdir(DIR);
       @files = grep(/\.(?:jpg|png|jpe|pdf|docx)$/,readdir(DIR));
#  @files = grep {!/^\.jpg+$/} readdir(DIR);
    close(DIR);
 
    if (!@files) {
        print "Script ended all files are in FTP.\n\n";
        last;
    }
 
    my $file = $files[0];
    my $old = "$srcdir/$file";
 
    move($old, $dest) or die "Move $old -> $dest failed: $!";
    print "File Name: $file moved to FTP - 30 mins for next upload.\n\n";
    sleep 10; # 10 Second
}
