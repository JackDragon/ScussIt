jQuery(document).ready(function($) {
	requestAiringToday(1)
	$(".frame").click(function(event) {
		detail = getDetails(this.id)
		redirectToChannel(detail)
	});
});

