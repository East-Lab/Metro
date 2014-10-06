<?php
class MetroAPI{
	private $baseurl = 'https://api.tokyometroapp.jp/api/v2/';
	private $nearStation = array(
		0 => array(
			0 => "永田町",
			1 => "赤坂見附",
		),
		1 => array(
			0 => "溜池山王",
			1 => "国会議事堂前",
		),
	);

	private function sendRequest($data, $api) {
		$accessToken = file_get_contents("/home/gif-animaker/Metro/API/metro.key");
		$accessToken = str_replace(array("\r\n","\r","\n"), '', $accessToken);
		$url = $this->baseurl . $api;

		$data['acl:consumerKey'] = $accessToken;

		$options = array('http' => array(
			'method' => 'GET',
			'content' => http_build_query($data),
		));
		$contents = file_get_contents($url, false, stream_context_create($options));

		return $contents;
	}

	private function isNearStation($stA, $stB) {
		foreach ($this->nearStation as $key => $value) {
			$count = 0;
			foreach ($value as $k => $v) {
				if ($stA === $v || $stB === $v) $count++;
			}
			if ($count >= 2) {
				return true;
			}
		}
		return false;
	}

	public function getPoiByLocation($lat, $lon, $radius, $count) {
		$data['rdf:type'] = 'ug:Poi'; 
		$data['lat'] = $lat; 
		$data['lon'] = $lon; 
		$data['radius'] = $radius; 
		$contents = json_decode($this->sendRequest($data, "places"), true);
		$result = array();
		$return = array();
		for($i = 0 ; $i<$count; $i++) {
			$r = $contents[$i];
			if (!$r["dc:title"]) {
				break;
			}
			$return[] = array(
				"title" => $r["dc:title"],
				"lat" => $r["geo:lat"],
				"lon" => $r["geo:long"],
			);
		} 
		$result['error'] = 0;
		$result['result'] = $return;
		return json_encode($result, JSON_UNESCAPED_UNICODE);
	}

	public function get2Point($latA, $lonA, $radiusA, $latB, $lonB, $radiusB, $count) {
		$conA = json_decode($this->getPoiByLocation($latA, $lonA, $radiusA, $count), true);
		$err = 0;
		$err_msg = "";
		if ($conA["error"] == 1) {
			$err_msg .= "[A] get poi error.\n";
			$err = 1;
		} else if($conA["result"].count == 0) {
			$err_msg .= "[A] no near point.\n";
			$err = 1;
		}
		$conB = json_decode($this->getPoiByLocation($latB, $lonB, $radiusB, 1), true);
		if ($conB["error"] == 1) {
			$err_msg .= "[B] get poi error.\n";
			$err = 1;
		} else if($conB["result"].count == 0) {
			$err_msg .= "[B] no near point.\n";
			$err = 1;
		}
		$arr = array();
		if ($err) {
			$arr = array();
		} else {
			for ($i = 0; $i < $count ; $i++) {
				if(!$conA["result"][$i]["title"]) break;
				$stationA = str_replace(strstr($conA["result"][$i]["title"], "出入口"),'',$conA["result"][$i]["title"]);
				$stationB = str_replace(strstr($conB["result"][0]["title"], "出入口"),'',$conB["result"][0]["title"]);
				if ($stationA !== $stationB && !$this->isNearStation($stationA, $stationB)) continue;
				$arr[] = array(
					"pointA" => array(
						"lat" => $conA["result"][$i]["lat"],
						"lon" => $conA["result"][$i]["lon"],
						"title" => $conA["result"][$i]["title"],
						"station" => $stationA,
					),
					"pointB" => array(
						"lat" => $conB["result"][0]["lat"],
						"lon" => $conB["result"][0]["lon"],
						"title" => $conB["result"][0]["title"],
						"station" => $stationB,
					),
				);
			}
		}
		$result = array(
			"error" => $err,
			"error_msg" => $err_msg,
			"result" => $arr,
		);
		return json_encode($result);
	}

	public function getTrainLocation() {
		$data['rdf:type'] = 'odpt:Train'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getTrainInfo() {
		$data['rdf:type'] = 'odpt:TrainInformation'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getStationTimetable($station) {
		$data['rdf:type'] = 'odpt:StationTimetable'; 
		$data['odpt:station'] = 'odpt.Station:' . $station;
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getStationFacility() {
		$data['rdf:type'] = 'odpt:StationFacility'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getPassengerSurvey() {
		$data['rdf:type'] = 'odpt:PassengerSurvey'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getRailwayFare() {
		$data['rdf:type'] = 'odpt:RailwayFare'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getStation() {
		$data['rdf:type'] = 'odpt:Station'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getPoi() {
		$data['rdf:type'] = 'ug:Poi'; 
		return json_decode($this->sendRequest($data, "datapoints"), true);
	}

	public function getStationByLocation($lat, $lon, $radius) {
		$data['rdf:type'] = 'mlit:Station'; 
		$data['lat'] = $lat; 
		$data['lon'] = $lon; 
		$data['radius'] = $radius; 
		return json_decode($this->sendRequest($data, "places"), true);
	}

	public function getRailwayByLocation($lat, $lon, $radius) {
		$data['rdf:type'] = 'mlit:Railway'; 
		$data['lat'] = $lat; 
		$data['lon'] = $lon; 
		$data['radius'] = $radius; 
		return json_decode($this->sendRequest($data, "places"), true);
	}
}
