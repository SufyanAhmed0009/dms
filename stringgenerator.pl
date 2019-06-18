
sub filegenerator{
my @chars = ("A".."Z", "a".."z");
my $string;

$i;

	$string .= $chars[rand @chars] for 1..8;
	#printf("$string\n");
	
return ($string);
}


$name=filegenerator();
printf("$name\n");