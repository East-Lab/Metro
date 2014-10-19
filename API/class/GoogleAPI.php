<?php
class GoogleAPI{
	private $baseurl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

	public function getAroundPlace($lat, $lon, $radius){
		$data['location'] = $lat . "," . $lon; 
		$data['radius'] = $radius; 
		$contents = json_decode($this->sendRequest($data), true);
		$arr = array();
		foreach ($contents["results"] as $res) {
			$res_arr = array(
				"name" => $res["name"],
				"location" => $res["geometry"]["location"],
			);
			$arr[] = $res_arr;
		}
		return array(
			"result" => $arr,
		);
	}

	private function sendRequest($data) {
		$accessToken = file_get_contents("/home/gif-animaker/Metro/API/google.key");
		$accessToken = str_replace(array("\r\n","\r","\n"), '', $accessToken);
		$url = $this->baseurl . "?language=ja&key=$accessToken&location={$data["location"]}&radius={$data["radius"]}&sensor={$data["sensor"]}";

		$options = array('https' => array(
			'method' => 'GET',
		));
		$contents = file_get_contents($url, false, stream_context_create($options));
		return $contents;
	}
}
