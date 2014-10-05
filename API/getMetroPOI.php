<?php
header("Content-Type: application/json; charset=utf-8");
require_once("/home/gif-animaker/Metro/API/class/MetroAPI.php");

$arg = $_GET;
$err = 0;
$err_msg = "";
if (!isset($arg["lat"])) {
	$err_msg .= "lat is not set.\n";
	$err = 1;
}
if (!isset($arg["lon"])) {
	$err_msg .= "lon is not set.\n";
	$err = 1;
}
if ($err) {
	$response = array(
		"error" => $err,
		"error_msg" => $err_msg,
	);
	echo json_encode($response);
	exit(0);
}

$metro = new MetroAPI();

$count = 10;
$contents = $metro->getPoiByLocation($arg["lat"],$arg["lon"],1000000);
$result = array();
$return = array();
for($i = 0 ; $i<$count ; $i++) {
	$r = $contents[$i];
	$return[] = array(
		"title" => $r["dc:title"],
		"lat" => $r["geo:lat"],
		"lon" => $r["geo:long"],
	);
} 
$result['error'] = $err;
$result['result'] = $return;

echo json_encode($result, JSON_UNESCAPED_UNICODE);
