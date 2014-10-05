<?php

require_once("./class/Request.php");
$req = new Request();

$contents = $req->getPoiByLocation(35.681265,139.766926,1000);
