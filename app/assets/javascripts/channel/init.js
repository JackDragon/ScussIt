jQuery(document).ready(function($) {
	detail = getDetails($(".browse_frame:first").attr("id"))
	setViewWithDetails(detail)


	$(".browse_frame").click(function(event) {
		detail = getDetails(this.id)
		setViewWithDetails(detail)
		$(".sidebar .follow").attr('value', this.id);
	});

	$(".sidebar .follow").click(function(event) {
		type = $(this).html()
		if (type == "Follow"){
			follow(detail)
		}else if(type == "Unfollow"){
			unfollow(detail)
		}
		
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
	toggleFollowButton(checkFollowing(detail["id"]))
}
function unfollow(detail){
	$.ajax({
		url: '/channel/unfollow',
		type: 'POST',
		data: {"api_id": detail['id']},
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
function follow(detail){
	$.ajax({
		url: '/channel/follow',
		type: 'POST',
		data: {"api_id": detail['id'], "name": detail['name'] , "image_url": detail['poster_url'], "network": detail['network']},
	})
	.done(function() {
		toggleFollowButton(true)
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}
function checkFollowing(id){
	isFollowing = false;
	$.ajax({
		url: '/channel/check_following/'+id,
		type: 'GET',
		dataType: 'json',
		async: false,
	})
	.done(function(data) {
		isFollowing = data["following"];
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
	return isFollowing
}
function toggleFollowButton(isFollowing){
	if (isFollowing){
		$(".sidebar .follow").html("Unfollow")
	}else{
		$(".sidebar .follow").html("Follow")
	}

}
