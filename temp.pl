#!/usr/bin/perl

#use strict;
#use warnings;
use Image::Magick;
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
# #######################################################################
# #scan file

my $sth= $dbh->prepare("SELECT idDocument, Document_description, path, mimeType from document; ");

$sth->execute() or die $DBI::errstr;

$docid;
$name;
$path;		
$type;




while(my @row1 = $sth->fetchrow_array()){
      
      printf("%s\t%s\t%s\t%s\n",$row1[0],$row1[1],$row1[2],$row1[3]);
      if($m==0){
		$docid = $row1[0];
		$name = $row1[1];
		$path =$row1[2];
		$type = $row1[3];
		
    	}    

#}
#query

my $sth1= $dbh->prepare("SELECT template_idtemplate,  Coordinates, idField, fieldName, dtType, idtType FROM `templatefield` where dtType='ocr' && idtType='document'  order by template_idtemplate, idField asc;");

$sth1->execute() or die $DBI::errstr;
 
#global variable
$mytemplateid;
$fieldid;      
      
 $i=0;
 $j=0;
 $flag =0;

 sub  trim {
	  my $s = shift;
	  $s =~ s/^\s+|\s+$//g;
	   return $s 
	   };
	   
	   
#$inputimage="zxc.jpg";
$inputimage= "$path$name$type"; 
  
  
  
  
  
  
  ###############################################################################################
  #DOCUMENT IDENTIFICATION
  
 while(my @row = $sth1->fetchrow_array()){

         
          if($i==0 && $j==0){
               $mytemplateid = $row[0];
               $cordinates = $row[1];
               $fieldid= $row[2];
		$fieldname = $row[3];
		$detection = $row[4];
		$identification = $row[5];
           }
       
                   printf ("template id :$row[0]\n");
                   printf ("field id :$row[2]\n");
     
                   push (@cordinates , $row[1]);
                   printf ("\ncordinates: $cordinates[0]\n");
         
    
            $image[i] = Image::Magick->new;
            
            ($width, $height, $size, $format) = $image[i]->Ping( $inputimage); 
        # printf("The Size of File is: $size Bytes \n The format is: $format \n");
        
        # printf("Width:$width and Height:$height \n");
        ############################################################
        #Read Scan File
		open(IMAGE, $inputimage );
            $image[i]->Read(file=>\*IMAGE);
		close(IMAGE);
	#############################################################
	#Image Cropping 	
             printf("crop:$i\n"); 
            $image[i]->Crop(geometry=>$cordinates[0]);
          #    $image->Crop(geometry=>@cordinates);
           #   $image->CopyPixels(geometry=>"704x136+909+404");
               
              
         #################################################      
         #Write Crop Image
                      $filename = "cropped/doccrop$i.jpg";
                     open(IMAGE, ">$filename");
                     $image[i]->Write(file=>\*IMAGE, filename=>$filename);
                     close(IMAGE);
               ($width, $height, $size, $format) = $image[i]->Ping($filename); 
                printf("The Size of File is: $size Bytes \n The format is: $format \n");
                printf("Width:$width and Height:$height \n");
                
                ######################################################################
                #Text Extraction OCR
			 $patch1=`tesseract  "$filename" stdout`;
			 $extractdata1=trim($patch1);
			 # if ($type==" "){
                             # printf("\nThe value is empty\n");
				 # }
                         
			 printf("\n$extractdata1\n");
                  
                printf ("\nImage is cropped\n");
             
                  shift (@cordinates);
              
                # printf("tempidd: $mytemplateid \n");
                # printf(" field id: $fieldid \n");
            
               
   #########################################################################33
  # Classification Of Document type            
               if($identification=="document"||"doc" &&  $detection =="ocr" &&  $fieldname==$extractdata1)
		{
			#printf("\nit is registration form\n");
			printf("\nit is $extractdata1\n");
			
			#if condition is satisfied then select the document type of document type table through the value of field 
			
			my $doctype= $dbh->prepare("SELECT idDocument_type, documentTypeName FROM document_type where documentTypeName like '$extractdata1';");
			$doctype->execute() or die $DBI::errstr;
			
			
			while(my @row1 = $doctype->fetchrow_array()){
				printf("%s\n", $row1[0]);
				$doctypeid=@row1[0];
				}
			# then update the document table and pass the id of document type to tag which type of document is. 	
			#printf("\n $doctypeid\n");
			printf("\n $docid\n");
			 $doc= $dbh->prepare("UPDATE document SET Document_type_idDocument_type = '.$doctypeid.', Document_size = '.$size.', mimeType = '.$format.' WHERE idDocument ='.$docid.';");#document id
			$doc->execute() or die $DBI::errstr;
		}
         
                 else{
			 printf("\nNot Found\n");
			 
			 
			 }
          $i++;
          $fieldid++;
          $type="";    
     }

# $sth->finish();


      
#######################################################
# 
  
  
  
printf("\n**************************************************************************\n");
#ENTITY IDENTIFICATION
  
   my $sth1= $dbh->prepare("SELECT template_idtemplate,  Coordinates, idField, fieldName, dtType, idtType FROM `templatefield` where dtType='ocr' && idtType='entity'  order by template_idtemplate, idField asc;");

  $sth1->execute() or die $DBI::errstr;
 
#global variable
#$mytemplateid;
#fieldid;      
      
 $k=0;
 $l=0;
 $flag =0;
 # print $sth->execute(),"\n";
 
 
 while(my @row= $sth1->fetchrow_array()){
	 
          if($k==0 && $l==0){
               $mytemplateid = $row[0];
               $cordinates = $row[1];
               $fieldid= $row[2];
		$fieldname = $row[3];
		$detection = $row[4];
		$identification = $row[5];
           }
       
                   printf ("template id :$row[0]\n");
                   printf ("field id :$row[2]\n");
     
                   push (@cordinates , $row[1]);
                   printf ("\ncordinates: $cordinates[0]\n");
         
    
            $image[k] = Image::Magick->new;
            
         #   ($width, $height, $size, $format) = $image[k]->Ping( $inputimage); 
        # printf("The Size of File is: $size Bytes \n The format is: $format \n");
        
        # printf("Width:$width and Height:$height \n");
       #Read scan file 
		open(IMAGE, $inputimage );
            $image[k]->Read(file=>\*IMAGE);
		close(IMAGE);
		
             printf("crop:$k\n"); 
             
            #Cropping The Image
            $image[k]->Crop(geometry=>$cordinates[0]);
          #    $image->Crop(geometry=>@cordinates);
           #   $image->CopyPixels(geometry=>"704x136+909+404");
               
              
            #Writing The Image File    
                      $filename2 = "cropped/entitycrop$k.jpg";
                     open(IMAGE, ">$filename2");
                     $image[k]->Write(file=>\*IMAGE, filename=>$filename2);
                     close(IMAGE);
               ($width, $height, $size, $format) = $image[i]->Ping($filename2); 
                printf("The Size of File is: $size Bytes \n The format is: $format \n");
                printf("Width:$width and Height:$height \n");
                
            #Text Extraction OCR
			 $patch2=`tesseract " $filename2" stdout`;
			 $owner=trim($patch2);
			 printf("\n$owner\n");
               
                printf ("\nImage is cropped\n");
             
                  shift (@cordinates);
              
                # printf("tempidd: $mytemplateid \n");
                # printf(" field id: $fieldid \n");
     ########################################################################3       
     # Classification Of Entity Type          
              
               if($identification=="entity"||"ENTITY" &&  $detection =="ocr" &&  $fieldname==$owner)
		{
			printf("\nThis Document is related to $owner\n");
			#printf("\nit is $type\n");
			
			#if condition is satisfied then select the document type of document type table through the value of field 
			
			 $sth2= $dbh->prepare("SELECT idEntity,Entity_name FROM entity WHERE Entity_name like '$owner';");
			
			$sth2->execute() or die $DBI::errstr;
			
			while(my @row1 = $sth2->fetchrow_array()){
				printf("%s\n", $row1[0]);
				$entityid=@row1[0];
				}
			
			# then update the document table and pass the id of document type to tag which type of document is. 	
			
			my $doc= $dbh->prepare("UPDATE document SET Entity_idEntity  = '.$entityid.' WHERE idDocument ='.$docid.' ;");#document id
			
			$doc->execute() or die $DBI::errstr;
		
		printf("\n**************************************************************************\n");
		
		printf("\ndocument ended\n");
		
		}
         
                 else{
			 printf("\nNot Found\n");
			 
			 
			 }
          $k++;
          $fieldid++;
          $type="";    
          }
  
# $m++;
# $id++;
}