//Difine angular module.
var metroMaps = angular.module('metro',[]);

metroMaps.controller('MapCtrl', function($scope){
  // coded by 10mon
  // 目的地の緯度,経度
  var directionLatLng = "35.681382,139.766084";

  var directionsDisplay = new google.maps.DirectionsRenderer();
  var directionsService = new google.maps.DirectionsService();

  $scope.initGL = function(e, selectedMarker) {
    // 現在地を取得
    navigator.geolocation.getCurrentPosition(
        function(pos) {
            initMap();
            calcRoute(pos.coords.latitude + "," + pos.coords.longitude);
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
$scope.initMap = function(e, selectedMarker) {
    var mapElm = document.getElementById("map");
    mapElm.style.width  = document.width  + "px";
    mapElm.style.height = document.height + "px";

    var option = {
        zoom: 18,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var gmap = new google.maps.Map(mapElm, option);
    directionsDisplay.setMap(gmap);
}


// ルート設定
$scope.calcRoute = function(e, originLatLng) {
    var mode = document.getElementById("mode").value;
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


}

});
