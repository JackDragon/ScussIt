
var end = 0;
var end_count = 0;


/**
 * Process json data for tv shows airing today
 * @param  {json} data
 * @param  {int} pageIndex
 * @return {void}
 */
function processAiringToday(data, pageIndex){
	var image_url = "https://image.tmdb.org/t/p/w185"
	var results = data["results"]
	var page = data["total_pages"]
	

	for (var i = 0; i < results.length; i++) {
		var tvshow = results[i]
		var poster = tvshow["poster_path"]
		var id = tvshow	["id"]
		var url = image_url+poster
		
		if (poster != null){
			appendImageToAiringToday(url,id)
			requestExternalID(id)
			// end+=240			
			// end_count++
		}
	}
	if(pageIndex < page){
		requestAiringToday(++pageIndex)	
	}
	if(pageIndex == page){
		// animateAiringToday()
	}
	
}
/**
 * Append image url to airing today frame
 * @param  {string} url
 * @return {void}
 */
function appendImageToAiringToday(url,id){
	$(".airing-today-frames").append("<div class='frame' id='"+id+"'><img src='"+ url +"' alt='' /></div>")
}

/**
 * Process json data for external IDs, specifically retreiving id for thetvdb API
 * @param  {json} data
 * @return {void}
 */
function processExternalID(data){
	var tvdb_id = data["tvdb_id"]
	var id = data["id"]

	if(tvdb_id != null){
		requestTVdb(tvdb_id, id)
	}

}
/**
 * Process json data from thetvdb API. Data includes time and ratings
 * @param  {json} data
 * @param  {int} id
 * @return {void}
 */
function processTVdb(data,id){
	tvdb_data = data["Data"]
	series = tvdb_data["Series"]
	airs_time = series["Airs_Time"]
	network = series["Network"]
	name = series["SeriesName"]
	appendTVdb(name, airs_time, network, id)
	
}
function appendTVdb(name, airs_time, network, id){
	$("#"+id).append("<li><ul><h2>" + name + "</h2></ul><ul>"+ airs_time + "</ul><ul>"+ network + "</ul></li>")
}
function animateAiringToday(){
	console.log(end)
	console.log(end_count)
	count = end_count*3000
	// console.log("end",end)
	// count =end_count;
	console.log(count)
	// end = $(".airing-today-frames").width()
	$(".airing-today-wrapper").animate({
		scrollLeft: end},
		count, function() {
			
		/* stuff to do after animation is complete */
	});
}
