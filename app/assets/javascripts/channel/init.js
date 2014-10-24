jQuery(document).ready(function($) {
	detail = getDetails($(".browse_frame:first").attr("id"))
	setViewWithDetails(detail)

	$(".browse_frame").click(function(event) {
		detail = getDetails(this.id)
		setViewWithDetails(detail)
		$(".sidebar .follow").attr('value', this.id);
	});

	$(".sidebar .follow").click(function(event) {
		console.log(detail)
		follow(detail)
	});
});

function getDetails(id){

	detail = null;
	$.ajax({
		url: '/browse/'+id,
		type: 'GET',
		dataType: 'json',
		async: false,
	})
	.done(function(data) {
		detail = data;
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});	
	
	return detail
	
}
function setViewWithDetails(detail){
	$(".sidebar p").html(detail["overview"])
	$(".sidebar h1").html(detail["name"])
}
function follow(detail){
	$.ajax({
		url: '/channel/follow',
		type: 'POST',
		data: {"api_id": detail['id'], "name": detail['name'] , "image_url": detail['poster_url'], "network": detail['network']},
	})
	.done(function() {
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}
