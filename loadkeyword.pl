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
my $database = "dms1";
my $dsn="DBI:$driver:database=$database";
my $userid ="root";
my $password="";


 my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;
 
	     sub filegenerator{
	    my @chars = ("A".."Z", "a".."z");
	    my $string;

	    $i;

		    $string .= $chars[rand @chars] for 1..8;
		    #printf("$string\n");
		    
	    return ($string);
	    }


 
    $k=0;
    $j=0;
    $file="";
    $old="";
    $docid;
    $keyspecifierid;
     my $n=0;
  
#my $srcdir = "/root/Tamoor/Scripts/folder1/";
#my $dest = "/root/Tamoor/Scripts/folder2/"; 

#my $srcdir = "C:/Users/sufya/Desktop/scripts/images";
#my $srcdir = "C:/Users/sufya/Desktop/New folder/folder2";
 my $srcdir = "folder2";
 my $dest = "folder3";
# #my $dest = "C:/Users/sufya/Desktop/New folder/folder3";
 
for (;;) { 
    opendir(DIR, $srcdir) or die "Can't open $srcdir: $!";
   # @files = grep {!/^\.+$/} readdir(DIR);
     # @files = grep(/\.png$/,readdir(DIR));
    @files = grep(/\.(?:jpg|png|jpe|pdf)$/,readdir(DIR));
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
    
# printf("$old\n");
    
 #  $i++; 
	# open(IMAGE, $files[0]);
            # $img=$image[k]->Read(file=>\*IMAGE);
		# close(IMAGE);
 
 
 
 
   $dest1="$dest/$file";
   # $dest1="folder2/line.png";
    
	# @in = `tesseract "$dest1" stdout`;
	# #@in =~ y/a-zA-Z0-9" "//cd;
	# $i=0;
	# while ($i<scalar @in){
		# $in[$i]=~ y/a-zA-Z0-9" "-//cd;
		# printf(".$in[$i].");

		# $i++;
		# }
	

 $systemFileName=filegenerator();
       
       my $the = $dbh->prepare(qq{select idDocument from document where generatedFileName like'$systemFileName'});
       $the->execute();
       my $found = 0;
      
       while (@row=$the->fetchrow_array()) 
       {
          $found = 1;
          printf("%s\n",$row[0]);
       }
       if ($found==0){
                $query2="insert into document ( userFileName,generatedFileName,path) values('$file','$systemFileName', '$dest1')";
                my $sth= $dbh->prepare($query2); 
               $sth->execute() or die $DBI::errstr;
               $docid=$sth->{mysql_insertid};
		printf("Document id:$docid\n");
          }
          else {
		printf("system file name is redundant");
           
           }
 
 # $dest1="folder2/600-01.png";
    
	# @in = `tesseract "$dest1" stdout`;
	 $inn = `tesseract "$dest1" stdout`;
	 $inn =~ y/a-zA-Z0-9" " "	"\r \n//cd;
	#@in =~ y/a-zA-Z0-9" "//cd;
	$i=0;
	


	@fields;
	@fields = split(' ',$inn);
	while($k< scalar @fields){
		#printf("$in[$k]");
		#printf("$ex[$k]");
		#@fields = split(' ',$in[$k]);
		
		printf("$fields[$k]\n ");
	 $k++;
	}
# @fields = split(' ',"");

	 $tempName;
	my $temp = $dbh->prepare(qq{select tempName from template });
	$temp->execute();
	while(my @templ = $temp->fetchrow_array()){
				printf("template name: %s\n", $row1[0]);
				$tempName=@templ[0];
				}



	while ($m< scalar @fields)
	{
	
	 $j=$fields[$m];
	#print "Field values are: $j\n";
	
	my $th = $dbh->prepare("select idKeyword from keyword where keyword_name like'$j'");
	$th->execute();
	my $found = 0;
	
	while (@row=$th->fetchrow_array()) 
	{
	    $keywordid;
	   $found = 1;
	   printf("keyword id: %s\n",$row[0]);
	   $keywordid=$row[0];
	}
	if ($found==0){
		my $query = "insert into keyword (Keyword_name) values ('$j')";
		my $sth= $dbh->prepare($query); 
		$sth->execute() or die $DBI::errstr;
		printf("New Keyword Is Inserted");
		
		#printf("%s\n",$row[0]);
		$keywordid=$sth->{mysql_insertid};
		printf("\nKeyword id:$keywordid\n");
		
		

		# my $sth2= $dbh->prepare("update key_specifier SET keyword_idKeyword = '$keywordid' where idkey_specifier ='$keyspecifierid';"); 
		# $sth2->execute() or die $DBI::errstr;
	}     
	$keywordName;
	my $th = $dbh->prepare(qq{select Keyword_name from keyword where idKeyword = '$keywordid'});
	$th->execute();
	while(my @row1 = $th->fetchrow_array()){
				printf("keyword name: %s\n", $row1[0]);
				$keywordName=@row1[0];
				}
	
	if ($tempName==$keywordName)
	    {
	    my $key= $dbh->prepare("insert into key_specifier (docid, Keyword_idKeyword,keyword_location_idkeyword_location) values('$docid','$keywordid',1);"); 
	    $key->execute() or die $DBI::errstr;
	    $keyspecifierid=$key->{mysql_insertid};
	    }
	else
	    {
	    my $key2= $dbh->prepare("insert into key_specifier (docid, Keyword_idKeyword,keyword_location_idkeyword_location) values('$docid','$keywordid',4);"); 
	    $key2->execute() or die $DBI::errstr;
	    $keyspecifierid=$key2->{mysql_insertid};
	    }
	    $n++;
	   #  $n=(++$n);
	    printf("value: $n\n");
	      $seq= $dbh->prepare("update key_specifier set key_sequence= '$n' where idkey_specifier = '$keyspecifierid';");
	      $seq->execute() or die $DBI::errstr;
	    
    $m++;
    
	}



	 
	# printf("\n$dest\n");
# my $sth= $dbh->prepare("insert into search (description, ocr) values('.$dest.', '.$in.');"); 
#my $sth= $dbh->prepare("insert into search (description, ocr) values('.$old.', '.@in.');"); 


#my $query = "insert into search (title, path, ocr) values('$file', '$dest1', ?)";




#@in =();

    print "\nFile Name: $file moved to Database - 10 second for next upload.\n\n";
    sleep 20; # 10 Second
    
    
 $k++;
 $j++
  }


