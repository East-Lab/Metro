 // 目的地の緯度,経度
//    var directionLatLng = "35.681382,139.766084";

    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();

    function initGL() {
        // 現在地を取得
        navigator.geolocation.getCurrentPosition(
            function(pos) {
                initMap();
                alert("1 ");
                getPoint(pos.coords.latitude, pos.coords.longitude);
                alert("2 ");
                calcRoute(pos.coords.latitude + "," + pos.coords.longitude, metroIn);
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
            destination: directionLatLngMetro,
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
          alert("a ");

          $("#result").html("");
            var title = data["result"][0]["title"];
            var latOut = data["result"][0]["lat"];
            var lonOut = data["result"][0]["lon"];
            var metroPoint = latOut + "," + lonOut;
            var start = lat + "," + lon;
            $("#result").append("title:" + title + "<br>lat:" + latOut + "<br>lon:" + lonOut + "<br>metro:" + metroPoint + "<br>start:" + start + "<hr>\n");

            alert("b ");
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
