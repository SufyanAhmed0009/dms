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
 
   $dest1="folder2/600-03.png";
    

$inn = `tesseract "$dest1" stdout`;
$inn =~ y/a-zA-Z0-9" "//cd;
$i=0;
# while ($i<scalar @in){
	# $in[$i]=~ y/a-zA-Z0-9" "\n-//cd;
	# #printf("$in[$i]");
	
	# $i++;
	# }
	

#@in="my name is sufyan";

@fields;
@fields = split(' ',$inn);
while($k< scalar @fields){
	#printf("$in[$k]");
	
	#@fields = split(' ',$in[$k]);
	
	printf("$fields[$k]\n ");
 $k++;}
# @fields = split(' ',"");



$m=0;while ($m< scalar @fields)
	{
	 $j=$fields[$m];	#print "Field values are: $j\n";
	# my $query2= "select idKeyword from keyword where keyword_name=='$j'";	my $th = $dbh->prepare(qq{select idKeyword from keyword where keyword_name like'$j'});
	$th->execute()or die $DBI::errstr;;
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
		printf("new keyword is inserted");
		#$lastid=$sth->{mysql_insertid};
		#printf("$lastid\n");
	}
	#my $query = "select documen";
	#	my $sth= $dbh->prepare($query); 
	#	$sth->execute() or die $DBI::errstr;
	$m++;
	}



