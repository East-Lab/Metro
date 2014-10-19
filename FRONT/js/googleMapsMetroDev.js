 // 目的地の緯度,経度
//    var directionLatLng = "35.681382,139.766084";

//    var map;
    var gmap;

    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    var markersArray = [];

    var initialLocationGlobal;

    function initGL() {
        //alert("initGl in");
        initMap();
        // 現在地を取得
        navigator.geolocation.watchPosition(
//        navigator.geolocation.getCurrentPosition(
            function(pos) {
              		var myLatlng = new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude);

                  initialLocationGlobal = myLatlng;

              		gmap.setCenter(myLatlng);

              		// マーカーの配列を空にする
              		if (markersArray) {
              			for (i in markersArray) {
              				markersArray[i].setMap(null);
              			}
              			markersArray.length = 0;
              		}

              		// マーカーを配列に格納する
                  var image = 'https://gif-animaker.sakura.ne.jp/metro/FRONT/js/images/bluedot.png';
              		var marker = new google.maps.Marker({
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
              		markersArray.push(marker);

              		// マーカーの配列を表示する
              		if (markersArray) {
              			for (i in markersArray) {
              				markersArray[i].setMap(gmap);
              			}
              		}
//                alert("1 ");
                // 現在地のマーカー表示
                /*
                var marker = new google.maps.Marker({
                  map:gmap,
                  draggable:false,
                  animation: google.maps.Animation.DROP,
                  position: pos,
                  title: "現在地"
                });
                */

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
        //alert("init map in");
        var mapElm = document.getElementById("map");
        mapElm.style.width  = document.width  + "px";
        mapElm.style.height = (document.height * 0.7) + "px";
//        mapElm.style.height = "250px";

        var option = {
            zoom: 18,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        gmap = new google.maps.Map(mapElm, option);

        // 現在地コントロール
        var homeControlDiv = document.createElement('DIV');
        var homeControl = new HomeControl(homeControlDiv, gmap);

        homeControlDiv.index = 1;
        gmap.controls[google.maps.ControlPosition.TOP_RIGHT].push(homeControlDiv);

        // Place検索
        var input = (document.getElementById('pac-input'));

        var autocomplete = new google.maps.places.Autocomplete(input);
        autocomplete.bindTo('bounds', gmap);

        var infowindow = new google.maps.InfoWindow();
        var marker = new google.maps.Marker({
          map: gmap,
          anchorPoint: new google.maps.Point(0, -29)
        });

        google.maps.event.addListener(autocomplete, 'place_changed', function() {
          infowindow.close();
          marker.setVisible(false);
          var place = autocomplete.getPlace();
          if (!place.geometry) {
            return;
          }

          // If the place has a geometry, then present it on a map.
          if (place.geometry.viewport) {
            gmap.fitBounds(place.geometry.viewport);
          } else {
            gmap.setCenter(place.geometry.location);
            gmap.setZoom(17);  // Why 17? Because it looks good.
          }
          marker.setIcon(/** @type {google.maps.Icon} */({
            url: place.icon,
            size: new google.maps.Size(71, 71),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(17, 34),
            scaledSize: new google.maps.Size(35, 35)
          }));
          marker.setPosition(place.geometry.location);
          marker.setVisible(true);

          var address = '';
          if (place.address_components) {
            address = [
              (place.address_components[0] && place.address_components[0].short_name || ''),
              (place.address_components[1] && place.address_components[1].short_name || ''),
              (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
          }

          infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
          infowindow.open(gmap, marker);
        });



        directionsDisplay.setMap(gmap);
        //alert("init map end");

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

$(function (){

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
                calcRoute(directionLatLng);
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
    map.setZoom(13);
    //map.setMapTypeId('satellite');
  });

}
