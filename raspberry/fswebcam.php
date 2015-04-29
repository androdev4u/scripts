<?php

// scan images and give them variable names for upload
// by Joerg Neikes aixTeMa GmbH

// http://host ip /fswebcam.php?picture=save&camera=0
// build a variable filename with GET
// do not use variable values exceeding 2000 chars!
// version 0.2
// added multicam

if((isset($_GET['picture'])) && (isset($_GET['camera'])) )
{

$picture=$_GET['picture'];
$camera=$_GET['camera'];

$picturenew="$picture" . "$camera";
// echo $picture;
$video="/dev/video" . $camera;

if (!headers_sent()) {

// create the image with fswebcam and save it to a directory with the
$_GET variable picture
$img = exec("/usr/bin/fswebcam -S 1  --rotate 270  -r 1280x1024 -d $video --no-title --no-timestamp --no-info --no-banner --jpeg 50 --save/tmp/". $picturenew. ".jpeg");

// set path to image with the $_GET variable to be read with
imagecreatefromjpeg
$image="/tmp/" . $picturenew .".jpeg";
$im=imagecreatefromjpeg($image);

// deliver the header for showing the image
header('Content-Type: image/jpeg');
header('Content-Disposition: filename="'.$picturenew.'.jpg"');
// show the image
imagejpeg($im);

} else {
echo 'Some error occoured!';
}

// to free the mem
imagedestroy($im);

} else {
echo "No GET variable set";
}

?>
