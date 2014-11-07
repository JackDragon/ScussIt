jQuery(document).ready(function($) {
	initialize()

});

function initialize(){
	id = $(".browse_frame:first").attr("id")
	if(id != null){
		detail = getDetails(id)
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
				unfollow(detail['id'])
			}
			
		});

		$(".sidebar .scuss").click(function(event) {
			redirectToChannel(detail);
		});
	}
	
}

function setViewWithDetails(detail){
	$(".sidebar .title").html(detail["name"])
	$(".sidebar .description").html(detail["overview"])
	toggleFollowButton(checkFollowing(detail["id"]))
}
function follow(detail){
	console.log(detail)
	$.ajax({
		url: '/channel/follow',
		type: 'POST',
		data: {"api_id": detail['id'], "name": detail['name'] , "image_url": detail['poster_path'], "network": detail['network']},
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

