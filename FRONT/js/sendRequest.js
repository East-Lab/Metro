$(function (){
	$("#btn").click(function(){
		console.log("click");
		$.ajax({
			url: "/metro/API/getMetroPOI.php",
			data: {
				lat : 35.6641222,
				lon : 139.729426
			},
			success: function( data ) {
				if (data.error == 1) {
					console.log("error!");
				} else {
					//console.log(data["result"]);
					for (var i=0 ; i<data["result"].length ; i++ ) {
						console.log(data["result"][i]["title"]);
					}
				}
			}
		});
	});
});



