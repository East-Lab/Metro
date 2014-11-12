<?php
header("Content-Type: application/json; charset=utf-8");
require_once("/home/gif-animaker/Metro/API/class/MetroAPI.php");


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
if (!isset($arg["radiusA"])) {
	$err_msg .= "radiusA is not set.\n";
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
if (!isset($arg["radiusB"])) {
	$err_msg .= "radiusB is not set.\n";
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

$contents = $metro->get2Point($arg["latA"],$arg["lonA"], $arg["radiusA"],$arg["latB"],$arg["lonB"], $arg["radiusB"], 40);
if ($arg["escape"]) {
	echo json_encode($contents, JSON_UNESCAPED_UNICODE);
} else {
	echo json_encode($contents);
}
