<?php
	
	$query="";
	$k="";
	if(isset($_REQUEST["k"])){
		$k=$_REQUEST["k"];
	}
	$conn=mysqli_connect("localhost", "root", "","dmsearch");

if (mysqli_connect_errno()) {
  #  echo("Connect failed: ".mysqli_connect_error());
    exit();
}else{
#	echo "Connected";
}
$data="";



				$terms = explode(" ",$k);
				$query .= "SELECT * FROM search WHERE ";

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
					$query .= "ocr LIKE '%$each%'";
					else
					$query .= "OR ocr LIKE '%$each%'";	
				}
		#echo($query);
		$results = mysqli_query($conn,$query);

			while (	$row = mysqli_fetch_assoc($results)) 
			{
				$id = $row['id'];
				$title = $row['title'];
				$description = $row['description'];
				$keywords = $row['keywords'];
				$link = $row['link'];
				$ocr = $row['ocr'];
				$type = $row['type'];

				$data.= "<h2><a href='$link'>$title</a></h2> $description<br/>";

				

		
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

	<h2>DCMS SEARCH ENGINE</h2>
	
	<form  method="get">
	<input type='text' align= "center" name='k' size='50' value='<?php  $k ?>' />
	<input type='submit' name='Search'/>
	</form> 
<hr />
<?php echo($data) ?>
<div >
<label>Document Photo</label>
<div>
<?php $docphoto=$row['path'];
$fpath=$row['path'].$row['title'].$row['type'];

if($docphoto==""):
?>
<h3>Result Not Found </h3>
<!--<img src="images/picp.png" width="700" height="1007" >-->
<!--echo ("No Image");-->
<?php else:?>
<!--$des="images/line.png";-->
  <!--<img src="<?php// echo $fpath ; ?>" width="700" height="1007" >-->
  <img src="<?php echo $row['path'] ; ?>" width="700" height="1007" >

<?php endif;?>

</div>

</div>
<?php  } ?>

</div>



		  

</body> 
</html>