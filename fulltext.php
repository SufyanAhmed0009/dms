<?php
	
	$query="";
	$k="";

	if(isset($_REQUEST["k"])){
		$k=$_REQUEST["k"];
	}
	$conn=mysqli_connect("localhost", "root", "","dms");

if (mysqli_connect_errno()) {
  #  echo("Connect failed: ".mysqli_connect_error());
    exit();
}else{
#	echo "Connected";
}
$data="";
//$terms="";
//$each="";


				$terms = explode(" ",$k);
				$query .= "SELECT DISTINCT document.path FROM document INNER JOIN key_specifier
                 ON Document.idDocument = key_specifier.docid INNER join keyword on key_specifier.Keyword_idKeyword= keyword.idKeyword 
                where";
  
				$i=0;	
				// foreach ($terms as $each)
				// {
				// 	$i++;
				// 	if ($i == 1)
				// 	$query .= "keywords LIKE '%$each%'";
				// 	else
				// 	$query .= "OR keywords LIKE '%$each%'";	
				// }

				foreach ($terms as $each)
				{
					$i++;
					if ($i == 1)
					$query .= "  MATCH (keyword.Keyword_name) AGAINST ('%$each%')  ";
					
					else
					$query .= " OR MATCH (keyword.Keyword_name ) AGAINST ('%$each%') ";	
				}
				$query .= "ORDER BY Keyword_name LIMIT 0, 33" ;
		#echo($query);
		$results = mysqli_query($conn,$query);
		#echo ($results);
		
		

				

			
		// else
		// 	echo "No results found for \"<b>$k<b/>\"";
		



		//disconnect
//ysql_close();

		

		
		 
	?>


<!DOCTYPE html>
<html>
<head>
<title>Search Engine - Results</title>
</head>
<body>

	<h1><center>DOCUMENT MANAGEMENT SYSTEM </center></h1>
	<h2><center>SEARCH ENGINE</center></h2>
	<form  method="get">
	<center><input type='text' align= "center" name='k' size='50' value='<?php  $k ?>' /></center>
	<center><input type='submit' name='Search'/></center>
	</form> 
<hr />
<?php //echo($data) ?>
<div >
<h2><center>Document Photo</center></h2>
<?php $j=0; ?>
<div>
<?php 

// $fpath=$row['path'].$row['title'].$row['type'];
	while (	$row = mysqli_fetch_assoc($results)) 
			{
						
				// $id = $row['id'];
				// $title = $row['title'];
				// $description = $row['description'];
				// $keywords = $row['keywords'];
				// $link = $row['link'];
				// $ocr = $row['ocr'];
				// $type = $row['type'];
				$docphoto=$row['path'];
				//echo ($path1);
				// $data.= "<h2><a href='$link'>$title</a></h2> $description<br/>";

//$docphoto="";
 if($docphoto==""): ?>
    echo "no image"; 
 
   // <h6> No Image </h6>

//<!--<h3>Result Not Found </h3>-->
//<!--<img src="images/picp.png" width="700" height="1007" >-->


//$docphoto=$row['path'];?>
<!--$des="images/line.png";-->
  <!--<img src="<?php// echo $fpath ; ?>" width="700" height="1007" >-->

<?php  else: ?>
 <center><h3> <?php $j++; echo ($j); ?> </h3></center>
 
 <center> <img src="<?php echo $docphoto ; ?>" width="700" height="1007" border="5"></center>
   
   <!--<img src="C:/xampp/htdocs/searchengine2/folder3/600-01.png" width="700" height="1007" >-->
<!--echo ("asdasda");-->

<?php endif; ?>

</div>

</div>

<?php } ?> 
 
 </div>


 
 





</body> 
</html>