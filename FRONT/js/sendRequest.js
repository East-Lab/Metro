$(function (){

	$("#gps_btn").click(function() {
		if (navigator.geolocation) {
			//Geolocation APIを利用できる環境向けの処理
			//console.log('can get geo');
			watchID = navigator.geolocation.getCurrentPosition(
				successCallback, errorCallback
				);
		} else {
			//Geolocation APIを利用できない環境向けの処理
			//console.log('cannot get geo');
		}
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



/***** 位置情報が取得できた場合 *****/
function successCallback(position) {
    var gl_text = "緯度：" + position.coords.latitude + "<br>";
    gl_text += "経度：" + position.coords.longitude + "<br>";
    gl_text += "高度：" + position.coords.altitude + "<br>";
    gl_text += "緯度・経度の誤差：" + position.coords.accuracy + "<br>";
    gl_text += "高度の誤差：" + position.coords.altitudeAccuracy + "<br>";
    gl_text += "方角：" + position.coords.heading + "<br>";
    gl_text += "速度：" + position.coords.speed + "<br>";
    //document.getElementById("show_result").innerHTML = gl_text;
    console.log(gl_text);
    //localStorage.setItem('usr_lat',position.coords.latitude);
    //localStorage.setItem('usr_lon',position.coords.longitude);
    //get_near_region(content);
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
