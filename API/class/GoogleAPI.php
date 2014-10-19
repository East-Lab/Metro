<?php
class GoogleAPI{
	private $baseurl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

	public function getAroundPlace($lat, $lon, $radius){
		$data['lat'] = $lat; 
		$data['lon'] = $lon; 
		$data['radius'] = $radius; 
		$self->sendRequest($data);
		$contents = json_decode($this->sendRequest($data), true);
		return $contents;
	}

	private function sendRequest($data) {
		$accessToken = file_get_contents("/home/gif-animaker/Metro/API/google.key");
		$accessToken = str_replace(array("\r\n","\r","\n"), '', $accessToken);
		$url = $this->baseurl;

		$data['key'] = $accessToken;

		$options = array('http' => array(
			'method' => 'GET',
			'content' => http_build_query($data),
		));
		$contents = file_get_contents($url, false, stream_context_create($options));

		return $contents;
	}

