<?php

require_once("/home/gif-animaker/Metro/API/class/MetroAPI.php");

$metro = new MetroAPI();

///$contents = $req->getTrainLocation();
//$contents = $req->getTrainInfo();
//$contents = $req->getStationTimetable('TokyoMetro.Chiyoda.Otemachi');
//$contents = $req->getStationFacility();
$contents = $req->getStation();
//$contents = $req->getPoiByLocation(35.681265,139.766926,1000);
//$contents = $metro->getPoi();
//$contents = $req->getStationByLocation(35.681265,139.766926,1000);
//var_dump($contents);
echo json_encode($contents);
