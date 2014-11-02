<?php
header("Content-Type: application/json; charset=utf-8");
require_once("/home/gif-animaker/Metro/API/class/GoogleAPI.php");

$arg = $_GET;
$err = 0;
$err_msg = "";
if (!isset($arg["latA"])) {
	$err_msg .= "latA is not set.\n";
	$err = 1;
}
if (!isset($arg["lonA"])) {
	$err_msg .= "lonA is not set.\n";
	$err = 1;
}
if (!isset($arg["latB"])) {
	$err_msg .= "latB is not set.\n";
	$err = 1;
}
if (!isset($arg["lonB"])) {
	$err_msg .= "lonB is not set.\n";
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

$google = new GoogleAPI();

$url = "http://maps.googleapis.com/maps/api/directions/json?origin={$arg["latA"]},{$arg["lonA"]}&destination={$arg["latB"]},{$arg["lonB"]}&mode=walking&sensor=false";
$contents = $google->sendRequest($url);
$data = json_decode($contents, true);
var_dump($data["routes"][0]["legs"][0]);
exit(0);
$steps = $data["routes"][0]["legs"]["steps"];
$arr = array();
foreach ($steps as $s) {
	$arr[] = array(
		"lat" => $steps["start_location"]["lat"],
		"lon" => $steps["start_location"]["lng"],
	);
} 
$arr[count($steps) - 1] = array(
	"lat" => $data["routes"][0]["legs"]["end_location"]["lat"],
	"lon" => $data["routes"][0]["legs"]["end_location"]["lng"],
);
if ($arg["escape"]) {
	echo json_encode($arr, JSON_UNESCAPED_UNICODE);
} else {
	echo json_encode($arr);
}
