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
if (!isset($arg["latC"])) {
	$err_msg .= "latC is not set.\n";
	$err = 1;
}
if (!isset($arg["lonC"])) {
	$err_msg .= "lonC is not set.\n";
	$err = 1;
}
if (!isset($arg["latD"])) {
	$err_msg .= "latD is not set.\n";
	$err = 1;
}
if (!isset($arg["lonD"])) {
	$err_msg .= "lonD is not set.\n";
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

$url = "http://maps.googleapis.com/maps/api/directions/json?origin={$arg["latA"]},{$arg["lonA"]}&destination={$arg["latD"]},{$arg["lonD"]}&mode=walking&waypoints={$arg["latB"]},{$arg["latB"]}|{$arg["latC"]},{$arg["latC"]}&sensor=false";
$contents = $google->sendRequest($url);
$data = json_decode($contents, true);
//var_dump($data["routes"][0]["legs"][0]["steps"][0]["start_location"]["lat"]);
var_dump($data);
exit(0);
$steps = $data["routes"][0]["legs"][0]["steps"];
$arr = array();
foreach ($steps as $s) {
	$arr[] = array(
		"lat" => $s["start_location"]["lat"],
		"lon" => $s["start_location"]["lng"],
	);
} 
$arr[count($steps) - 1] = array(
	"lat" => $data["routes"][0]["legs"][0]["end_location"]["lat"],
	"lon" => $data["routes"][0]["legs"][0]["end_location"]["lng"],
);
$return = array(
	"res" => $arr,
	"polyline" => $data["routes"][0]["overview_polyline"]["points"],
);
if ($arg["escape"]) {
	echo json_encode($return, JSON_UNESCAPED_UNICODE);
} else {
	echo json_encode($return);
}
