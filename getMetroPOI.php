<?php

require_once("./class/MetroAPI.php");

$arg = $_GET;

$metro = new MetroAPI();

$contents = $metro->getPoiByLocation(35.681265,139.766926,1000);
var_dump($arg);
//echo json_encode($contents);
