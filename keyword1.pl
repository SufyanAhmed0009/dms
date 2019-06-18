#!/usr/bin/perl

#use strict;
#use warnings;

use DBI;



###################################################################
   
#####################################################################

#database connection
my $driver = "mysql";
my $database = "dms";
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





 
  $dest1="folder2/600-01.png";
    
	# @in = `tesseract "$dest1" stdout`;
	 $inn = `tesseract "$dest1" stdout`;
	 $inn =~ y/a-zA-Z0-9" "//cd;
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




while ($m< scalar @fields)
{
 $j=$fields[$m];
#print "Field values are: $j\n";
# my $query2= "select idKeyword from keyword where keyword_name=='$j'";
  # if ($j==)
  
  


my $th = $dbh->prepare(qq{select idKeyword from keyword where keyword_name like'$j'});
$th->execute();
my $found = 0;
while (@row=$th->fetchrow_array()) 
{
   $found = 1;
   printf("%s\n",$row[0]);
}
if ($found==0){
	my $query = "insert into keyword (Keyword_name) values ('$j')";
	my $sth= $dbh->prepare($query); 
	$sth->execute() or die $DBI::errstr;
	printf("IF statement is executed");
	
	#printf("%s\n",$row[0]);
	$lastid=$sth->{mysql_insertid};
	printf("$lastid\n");
}     
        
$m++;
}


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
                $query2="insert into document ( generatedFileName,path) values('$systemFileName', '$dest1')";
                my $sth= $dbh->prepare($query2); 
               $sth->execute() or die $DBI::errstr;
          
          }







