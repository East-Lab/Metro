$(function (){

	$("#gps_btn").click(function() {
		get_geo();
	});

	$("#btn").click(function(){
		console.log("click");
		$.ajax({
			url: "/metro/API/getMetroPOI.php",
			data: {
				lat : 35.6641222,
				lon : 139.729426
			},
			beforeSend: function() {
				$("#result").html("loading...");
			},
			success: function( data ) {
				if (data.error == 1) {
					$("#result").html(data["error_msg"]);
				} else {
					$("#result").html("");
					for (var i=0 ; i<data["result"].length ; i++ ) {
						var title = data["result"][i]["title"];
						var lat = data["result"][i]["lat"];
						var lon = data["result"][i]["lon"];
						$("#result").append("title:" + title + "<br>lat:" + lat + "<br>lon:" + lon + "<hr>\n");
					}
				}
			}
		});
	});
});

function get_geo() {
	if (navigator.geolocation) {
		//Geolocation APIを利用できる環境向けの処理
		//console.log('can get geo');
		watchID = navigator.geolocation.getCurrentPosition(
				successCallback, errorCallback
				);
	} else {
		//Geolocation APIを利用できない環境向けの処理
		console.log('cannot get geo');
	}
}


/***** 位置情報が取得できた場合 *****/
function successCallback(position) {
    var gl_text = "緯度：" + position.coords.latitude + "<br>";
    gl_text += "経度：" + position.coords.longitude + "<br>";
	$("#geo").html(gl_text);
	get_geo();
}

/***** 位置情報が取得できない場合 *****/
function errorCallback(error) {
    var err_msg = "";
    switch(error.code)
    {
        case 1:
            err_msg = "位置情報の利用が許可されていません";
            break;
        case 2:
            err_msg = "デバイスの位置が判定できません";
            break;
        case 3:
            err_msg = "タイムアウトしました";
            break;
    }
}
