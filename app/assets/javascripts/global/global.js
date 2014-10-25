// Jon Wu
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

function unfollow(id){
	$.ajax({
		url: '/channel/unfollow',
		type: 'POST',
		data: {"api_id": id},
	})
	.done(function() {
		toggleFollowButton(false)
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}

function toggleFollowButton(isFollowing){
	if (isFollowing){
		$(" .follow").html("Unfollow")
	}else{
		$(" .follow").html("Follow")
	}

}
