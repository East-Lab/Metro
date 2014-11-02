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
if ($arg["escape"]) {
	echo json_encode($contents, JSON_UNESCAPED_UNICODE);
} else {
	echo json_encode($contents);
}
