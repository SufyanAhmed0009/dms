#!/usr/bin/perl

#use strict;
#use warnings;
use Image::Magick;
use DBI;
use File::Copy;


###################################################################
   
#####################################################################

#database connection
my $driver = "mysql";
my $database = "dmsearch";
my $dsn="DBI:$driver:database=$database";
my $userid ="root";
my $password="";


 my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;
 
$k=0;
$j=0;
  $file="";
  $old="";
  
#my $srcdir = "/root/Tamoor/Scripts/folder1/";
#my $dest = "/root/Tamoor/Scripts/folder2/"; 

#my $srcdir = "C:/Users/sufya/Desktop/scripts/images";
#my $srcdir = "C:/Users/sufya/Desktop/New folder/folder2";
my $srcdir = "folder2";
my $dest = "folder3";
#my $dest = "C:/Users/sufya/Desktop/New folder/folder3";
 
for (;;) { 
    opendir(DIR, $srcdir) or die "Can't open $srcdir: $!";
   # @files = grep {!/^\.+$/} readdir(DIR);
      @files = grep(/\.jpg$/,readdir(DIR));
       # @files = grep( /\.png$/,readdir(DIR));
#	@files=grep ".*\.zip$";
	# @files = grep(/\.png/ || \.jpg$/,readdir(DIR));
#  @files = grep {!/^\.jpg+$/} readdir(DIR);


  # $image[k] = Image::Magick->new;
            
         #   ($width, $height, $size, $format) = $image[k]->Ping( $inputimage); 
        # printf("The Size of File is: $size Bytes \n The format is: $format \n");
        
        # printf("Width:$width and Height:$height \n");
       #Read scan file 
       
       close(DIR);

		
   
 
    if (!@files[$j]) {
        print "Script ended all files are in FTP.\n\n";
        last;
    }

    $file = $files[$j];

	printf("$file\n");
     $old = "$srcdir/$file";
    #  $old = "$dest/$file";
    
    move($old, $dest) or die "Move $old -> $dest failed: $!";
    
printf("$old\n");
    
 #  $i++; 
	# open(IMAGE, $files[0]);
            # $img=$image[k]->Read(file=>\*IMAGE);
		# close(IMAGE);
 
 
 
 
    $dest1="$dest/$file";
    
	@in = `tesseract "$dest1" stdout`;
	#@in =~ y/a-zA-Z0-9" "//cd;
	$i=0;
	while ($i<scalar @in){
		$in[$i]=~ y/a-zA-Z0-9" "-//cd;
		printf(".$in[$i].");

		$i++;
		}
	

	
	 
	# printf("\n$dest\n");
# my $sth= $dbh->prepare("insert into search (description, ocr) values('.$dest.', '.$in.');"); 
#my $sth= $dbh->prepare("insert into search (description, ocr) values('.$old.', '.@in.');"); 


#my $query = "insert into search (title, path, ocr) values('$file', '$dest1', ?)";




 @in =();

    print "\nFile Name: $file moved to Database - 10 second for next upload.\n\n";
    sleep 20; # 10 Second
    
    
 $k++;
 $j++
}


