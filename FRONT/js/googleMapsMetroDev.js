 // 目的地の緯度,経度
//    var directionLatLng = "35.681382,139.766084";

//    var map;
    var gmap;

    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var markersArray = [];

    var initialLocationGlobal;

    var orientLocationLat;
    var orientLocationLon;

    var nearMetroIn;
    var nearMetroOut;

    var initFlg = 1;

    function initGL() {
      // 目的地ボタンの無効化
      $('#btn_mokuteki').attr('disabled', true);
//        alert("initGl in");
        initMap();
        // 現在地を取得
        navigator.geolocation.watchPosition(
            function(pos) {
              		var myLatlng = new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude);

                  initialLocationGlobal = myLatlng;

                  if(initFlg == 1){
              		    gmap.setCenter(myLatlng);
                      initFlg = 0;
                  }

              		// マーカーの配列を空にする
              		if (markersArray) {
              			for (i in markersArray) {
              				markersArray[i].setMap(null);
              			}
              			markersArray.length = 0;
              		}

              		// マーカーを配列に格納する
                  var image = 'https://gif-animaker.sakura.ne.jp/metro/FRONT/js/images/bluedot.png';
              		var nowMarker = new google.maps.Marker({
              			position: myLatlng,
              			map: gmap,
              			title: "Maybe you are here now.",
                    icon:  new google.maps.MarkerImage(
                        image,                     // url
//                        new google.maps.Size(17,17), // size
                        null,                           //size
//                        new google.maps.Point(0,15),  // origin
                        null,                          // origin
                        new google.maps.Point(8,8),    // anchor
                        new google.maps.Size(17, 17)  //scaled size
                    )
              		});
              		markersArray.push(nowMarker);

              		// マーカーの配列を表示する
              		if (markersArray) {
              			for (i in markersArray) {
              				markersArray[i].setMap(gmap);
              			}
              		}

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
//                alert(msg, "call init");

                initMap();

                //calcRoute(directionLatLng);
	          },
            {
                enableHighAccuracy:true, timeout:15000, maximumAge:15000
            }
        );
    }

    // 地図の初期化
    function initMap() {
//        alert("init map in");

        if(initFlg == 0){
            initFlg = 1;
        }

        var mapElm = document.getElementById("map");
        mapElm.style.width  = document.width  + "px";
        mapElm.style.height = (document.height * 0.7) + "px";
//        mapElm.style.height = "250px";

        var option = {
            zoom: 18,
            mapTypeControl:false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        gmap = new google.maps.Map(mapElm, option);

        // 現在地コントロール
        var homeControlDiv = document.createElement('div');
        var homeControl = new HomeControl(homeControlDiv, gmap);

        homeControlDiv.index = 1;
        gmap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(homeControlDiv);

        // タッチした場所にピンを立てる
        google.maps.event.addListener(gmap, 'click', function(e) {
          placeMarker(e.latLng, gmap);
        });


        directionsDisplay.setMap(gmap);
//        alert("init map end");

    }

    // Place検索ライブラリ


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
  //        alert("a ");

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

// Metro API
function goToPoint(latNow, lonNow, latOrient, lonOrient){
  alert("func in " + latOrient + "," + lonOrient);
    $.ajax({
      url: "/metro/API/get2Point.php",
      data: {
        latA : latNow,
        lonA : lonNow,
        radiusA : 100000,
        latB : latOrient,
        lonB : lonOrient,
        radiusB : 100000
      },
      beforeSend: function() {
        $("#result").html("loading...");
      },
      success: function( data ) {
        if (data.error == 1) {
          $("#result").html(data["error_msg"]);
        } else {
          alert("to mokuteki");

          $("#result").html("");
            var titleA = data["result"][0]["pointA"]["title"];
            var latOutA = data["result"][0]["pointA"]["lat"];
            var lonOutA = data["result"][0]["pointA"]["lon"];
            var titleB = data["result"][0]["pointB"]["title"];
            var latOutB = data["result"][0]["pointB"]["lat"];
            var lonOutB = data["result"][0]["pointB"]["lon"];

            //var metroPoint = latOut + "," + lonOut;
            //var start = lat + "," + lon;

            var start = latNow + "," + lonNow;
            var startMetroOut = latOutA + "," + lonOutA;

            var startMetroOut = latOutB + "," + lonOutB;
            var orient = latOrient + "," + lonOrient;

            //$("#result").append("title:" + title + "<br>lat:" + latOut + "<br>lon:" + lonOut + "<br>metro:" + metroPoint + "<br>start:" + start + "<hr>\n");

//            alert("b " + start + " " + metroPoint);
            calcRoute(start, startMetroOut);
            calcRoute(startMetroOut, orient);

            return "success";

        }
      }
    });
}


// Metro API
function getStationSpot(lat, lon){
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
  //        alert("a ");

          $("#result").html("");
            var title = data["result"][0]["title"];
            var latOut = data["result"][0]["lat"];
            var lonOut = data["result"][0]["lon"];
            var metroPoint = latOut + "," + lonOut;
            var start = lat + "," + lon;
            $("#result").append("title:" + title + "<br>lat:" + latOut + "<br>lon:" + lonOut + "<br>metro:" + metroPoint + "<br>start:" + start + "<hr>\n");

            return metroPoint;

        }
      }
    });
}


$(function (){
//とりあえず地下へ
  $("#btn_toriaezu").click(function(){
      navigator.geolocation.getCurrentPosition(
            function(pos) {
              getPoint(pos.coords.latitude, pos.coords.longitude);
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
                //calcRoute(directionLatLng);
	          },
            {
                enableHighAccuracy:true, timeout:15000, maximumAge:15000
            }
      );


  });

//目的地へ
  $("#btn_mokuteki").click(function(){
      navigator.geolocation.getCurrentPosition(
            function(pos) {
              alert("mokuteki btn pushed " + orientLocationLat + "," + orientLocationLon);
              goToPoint(pos.coords.latitude, pos.coords.longitude, orientLocationLat, orientLocationLon);
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
                //calcRoute(directionLatLng);
            },
            {
                enableHighAccuracy:true, timeout:15000, maximumAge:15000
            }
      );


  });


});

//◆現在地コントロール
function HomeControl(controlDiv, map){

  //マップ端から5pxのオフセット
  controlDiv.style.padding = '5px';

  // コントロールボタン ボーダー用CSS
  var controlUI = document.createElement('DIV');
  controlUI.style.backgroundColor = 'white';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '2px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Click to set the map to Home';
  controlDiv.appendChild(controlUI);

  // コントロールボタン装飾用CSS
  var controlText = document.createElement('DIV');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.paddingLeft = '4px';
  controlText.style.paddingRight = '4px';
  controlText.innerHTML = '<b>現在地</b>';
  controlUI.appendChild(controlText);


  //現在地へ移動
  google.maps.event.addDomListener(controlUI, 'click', function(){
    map.setCenter(initialLocationGlobal);
    map.setZoom(18);
    //map.setMapTypeId('satellite');
  });


}

// タッチしたところにピンを立てる
function placeMarker(position, map) {
  var marker = new google.maps.Marker({
    position: position,
    map: map
  });
  map.panTo(position);

  alert("pos " + position.lat());
  alert("pos " + position.lon());

  orientLocationLat = position.lat();
  orientLocationLon = position.lon();
  //orientLocation = latOut + "," + lonOut;


  alert("able");
  $('#btn_mokuteki').attr('disabled', false);
}
