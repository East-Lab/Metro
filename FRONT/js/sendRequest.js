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
				console.log(data);
			}
		});
	});
});



