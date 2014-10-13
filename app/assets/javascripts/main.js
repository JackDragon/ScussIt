var api_key = "8dbcc916cb5179dbcc6f9c06145f3085"
var endpoint = "https://api.themoviedb.org/3/"
var airing_today = "tv/airing_today"


$.ajax({
	url: endpoint+airing_today,
	type: 'GET',
	dataType: 'json',
	data: {"api_key": api_key},
})
.done(function(data) {
	processAiringToday(data)
	console.log("success");
})
.fail(function() {
	console.log("error");
})
.always(function() {
	console.log("complete");
});

var image_url = "https://image.tmdb.org/t/p/w185"

function processAiringToday(data){
	var results = data["results"]
	var url = []
	for (var i = 0; i < results.length; i++) {
		tvshow = results[i]
		poster = tvshow["poster_path"]
		url[i] = image_url+poster
	}
	i = 0
	$(".frame img").each(function(index, el) {
		$(this).attr('src', url[i++]);
		
	});
	console.log(url)
}