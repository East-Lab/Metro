<?php
header("Content-Type: application/json; charset=utf-8");
require_once("/home/gif-animaker/Metro/API/class/GoogleAPI.php");
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
if (!isset($arg["radius"])) {
	$err_msg .= "radius is not set.\n";
	$err = 1;
}
if (!isset($arg["escape"])) {
	$arg["escape"] = 1;
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
$contents = $metro->getPoiByLocation($arg["lat"],$arg["lon"], $arg["radius"], 1);
$poi = $contents['result'][0]['title'];
$station = str_replace(strstr($poi, "出入口"),'駅',$poi);
echo $station;




/*
$google = new GoogleAPI();

$contents = $google->getAroundPlace($arg["lat"],$arg["lon"], $arg["radius"]);
if ($arg["escape"]) {
	echo json_encode($contents, JSON_UNESCAPED_UNICODE);
} else {
	echo json_encode($contents);
}
 */
