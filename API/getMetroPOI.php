<?php

require_once("/home/gif-animaker/class/Request.php");

$arg = $_GET;

$metro = new MetroAPI();

$contents = $metro->getPoiByLocation(35.681265,139.766926,1000);
//var_dump($arg);
echo json_encode($contents);
