jQuery(document).ready(function($) {
	getDetails($(".browse_frame:first").attr("id"))

	$(".browse_frame").click(function(event) {
		// console.log(this.id)
		$(".sidebar .follow").attr('value', this.id);
		getDetails(this.id)

	});

	$(".sidebar .follow").click(function(event) {
		console.log($(this).attr('value'))
	});
});

function getDetails(id){
	$.ajax({
		url: '/browse/'+id,
		type: 'GET',
		dataType: 'json',
	})
	.done(function(data) {
		console.log(data)
		$(".sidebar p").html(data["overview"])
		$(".sidebar h1").html(data["name"])
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}
