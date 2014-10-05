$(function (){
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
					$("#result").html("error");
				} else {
					$("#result").html("");
					for (var i=0 ; i<data["result"].length ; i++ ) {
						var title = data["result"][i]["title"];
						var lat = data["result"][i]["lat"];
						var lon = data["result"][i]["lon"];
						$("#result").append("title:" + title + "&lat:" + lat + "&lon:" + lon + "<br>\n");
					}
				}
			}
		});
	});
});
