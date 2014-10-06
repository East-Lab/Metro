<?php

require_once("/home/gif-animaker/Metro/API/class/MetroAPI.php");

$metro = new MetroAPI();

///$contents = $metro->getTrainLocation();
//$contents = $metro->getTrainInfo();
//$contents = $metro->getStationTimetable('TokyoMetro.Chiyoda.Otemachi');
//$contents = $metro->getStationFacility();
$contents = $metro->getStation();
//$contents = $metro->getPoiByLocation(35.681265,139.766926,1000);
//$contents = $metro->getPoi();
//$contents = $metro->getStationByLocation(35.681265,139.766926,1000);
//var_dump($contents);
echo json_encode($contents);
