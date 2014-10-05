<?php

require_once("./class/Request.php");

$req = new Request();

///$contents = $req->getTrainLocation();
//$contents = $req->getTrainInfo();
//$contents = $req->getStationTimetable('TokyoMetro.Chiyoda.Otemachi');
//$contents = $req->getStationFacility();
//$contents = $req->getStation();
//$contents = $req->getPoiByLocation(35.681265,139.766926,1000);
$contents = $req->getPoi();
//$contents = $req->getStationByLocation(35.681265,139.766926,1000);
//var_dump($contents);
echo json_encode($contents);
