<?php
class MetroAPI{
	private $accessToken = '8615107f491101906849096652f4c208220cc3ea47b42915f7dd355c7eba82b0';
	private $baseurl = 'https://api.tokyometroapp.jp/api/v2/';

	private function sendRequest($data, $api) {
		$url = $this->baseurl . $api;

		$data['acl:consumerKey'] = $this->accessToken;

		$options = array('http' => array(
			'method' => 'GET',
			'content' => http_build_query($data),
		));
		$contents = file_get_contents($url, false, stream_context_create($options));

		return $contents;
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

	public function getPoiByLocation($lat, $lon, $radius) {
		$data['rdf:type'] = 'ug:Poi'; 
		$data['lat'] = $lat; 
		$data['lon'] = $lon; 
		$data['radius'] = $radius; 
		return json_decode($this->sendRequest($data, "places"), true);
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
