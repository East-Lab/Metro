 // 目的地の緯度,経度
//    var directionLatLng = "35.681382,139.766084";

    var map;

    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();

    function initGL() {
        // 現在地を取得
        navigator.geolocation.getCurrentPosition(
            function(pos) {
                initMap();
//                alert("1 ");
//                  getPoint(pos.coords.latitude, pos.coords.longitude);
//                  initialize(pos.coords.latitude, pos.coords.longitude);
//                alert("2 " + metroIn);
//                calcRoute(pos.coords.latitude + "," + pos.coords.longitude, metroIn);

            },
            function(error) {
                var msg = "";
                switch (error.code) {
                case error.PERMISSION_DENIED:
                    msg = "位置情報の取得の使用が許可されませんでした。";
                    break;
                case error.PERMISSION_DENIED_TIMEOUT:
                    msg = "位置情報の取得中にタイムアウトしました。";
                    break;
                default: // case error.POSITION_UNAVAILABLE:
                    msg = "位置情報が取得できませんでした。";
                }
                alert(msg);

                initMap();

                calcRoute(directionLatLng);
	          },
            {
                enableHighAccuracy:true, timeout:15000, maximumAge:15000
            }
        );
    }

    // 地図の初期化
    function initMap() {
        var mapElm = document.getElementById("map");
        mapElm.style.width  = document.width  + "px";
        mapElm.style.height = (document.height * 0.7) + "px";
//        mapElm.style.height = "250px";

        var option = {
            zoom: 18,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var gmap = new google.maps.Map(mapElm, option);
        directionsDisplay.setMap(gmap);
    }

    // ルート設定
    function calcRoute(originLatLng, directionLatLng) {
        //alert(originLatLng);
        //alert(directionLatLng);

        var mode = "WALKING";
        var req = {
            origin: originLatLng,
            destination: directionLatLng,
            travelMode: google.maps.TravelMode[mode]
        };
        directionsService.route(req, function(res, status) {
            if (google.maps.DirectionsStatus.OK == status) {
                directionsDisplay.setDirections(res);
            }
	      });
    }



// Metro API
function getPoint(lat, lon){
    console.log("click");
    $.ajax({
      url: "/metro/API/getMetroPOI.php",
      data: {
        //lat : 35.6641222,
        //lon : 139.729426
        lat : lat,
        lon : lon,
        radius : 100000
      },
      beforeSend: function() {
        $("#result").html("loading...");
      },
      success: function( data ) {
        if (data.error == 1) {
          $("#result").html(data["error_msg"]);
        } else {
//          alert("a ");

          $("#result").html("");
            var title = data["result"][0]["title"];
            var latOut = data["result"][0]["lat"];
            var lonOut = data["result"][0]["lon"];
            var metroPoint = latOut + "," + lonOut;
            var start = lat + "," + lon;
            $("#result").append("title:" + title + "<br>lat:" + latOut + "<br>lon:" + lonOut + "<br>metro:" + metroPoint + "<br>start:" + start + "<hr>\n");

//            alert("b " + start + " " + metroPoint);
            calcRoute(start, metroPoint);

            return metroPoint;

        }
      }
    });
}

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
  lat = position.coords.latitude;
  lon = position.coords.longitude;

    var gl_text = "lat : " + position.coords.latitude + "<br>";
    gl_text += "lon : " + position.coords.longitude + "<br>";
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


// initialize
// マップオブジェクトを作成し、マーカーを表示
function initGL2(){
  alert("initialize in");

	var myLatLng = geoLocate(); // MAPの初期位置

	if (myLatLng == null){ // 位置情報取得に失敗した場合、東京駅をセンターにしてMAP表示
		myLatLng = new google.maps.LatLng(35.681382, 139.766084);
	}
	var mapOptions = {
		center: myLatLng,
		zoom:18,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map(document.getElementById("map"), mapOptions);

	// ユーザのマーカーアイコンを変更
	var markerImage = new google.maps.MarkerImage(
		// 画像の場所
		"image/bluedot.png",
		// マーカーのサイズ
		new google.maps.Size(20, 24),
		// 画像の基準位置
		new google.maps.Point(0, 0),
		// Anchorポイント
		new google.maps.Point(10, 24)
	);

	// 現在地のマーカー表示
	var marker = new google.maps.Marker({
		map:map,
		draggable:false,
		animation: google.maps.Animation.DROP,
		position: myLatLng,
		title: "現在地",
		icon: markerImage
	});

}

//google.maps.event.addDomListener(window, 'load', initialize); // Windowがロードされたとき表示させる


// 現在地取得
function geoLocate(){
  alert("geolocate in");
  // 位置情報取得のオプション。高精度にする
  var position_options = {
    enableHightAccuracy: true
  };
  // 現在地取得（変わる毎に更新）
  navigator.geolocation.watchPosition(success, fatal, position_options);

  //位置情報取得成功時
  function success(position){
    var myLatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    return myLatLng;
  }

  // 位置情報取得失敗時
  function fatal(error){
    var message = "";

    switch(error.code){
      // 位置情報が取得出来ない場合
      case error.POSITION_UNAVAILABLE:
        message = "位置情報の取得ができませんでした。";
        break;
      // Geolocationの使用が許可されない場合
      case error.PERMISSION_DENIED:
        message = "位置情報取得の使用許可がされませんでした。";
        break;
      // タイムアウトした場合
      case error.PERMISSION_DENIED_TIMEOUT:
        message = "位置情報取得中にタイムアウトしました。";
        break;
    }
    window.alert(message);
    return null;
  }
}
