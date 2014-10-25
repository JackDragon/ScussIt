function redirectToChannel(detail){
	$.ajax({
		url: '/find',
		type: 'GET',
		data: {"api_id": detail['id'], "name": detail['name'], "image_url": detail['poster_url'], "network": detail['network']},
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