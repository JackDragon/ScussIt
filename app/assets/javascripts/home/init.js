jQuery(document).ready(function($) {
	
	$(".frame").click(function(event) {
		detail = getDetails(this.id)
		console.log(detail)
		redirectToChannel(detail)
	});
});

