var themoviedb = {
	api_key: "8dbcc916cb5179dbcc6f9c06145f3085",
	endpoint: "https://api.themoviedb.org/3",
	airing_today: "/tv/airing_today",
	tv: "/tv/",
	external_ids:"/external_ids"
}

var thetvdb={
	api_key: "7FE56AB14EBC6348",
	endpoint: "http://thetvdb.com"
}


console.log(themoviedb['endpoint']+themoviedb['airing_today']+"?api_key="+themoviedb['api_key'])

jQuery(document).ready(function($) {
	requestAiringToday(1)
	
});

function requestAiringToday(page){
	$.ajax({
		url: themoviedb['endpoint']+themoviedb['airing_today'],
		type: 'GET',
		dataType: 'json',
		cache: false,
		data: {"api_key": themoviedb['api_key'], "page": page},
	})
	.done(function(data) {
		processAiringToday(data, page)
		// console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
}

function requestExternalID(id){
	$.ajax({
		url: themoviedb['endpoint']+themoviedb['tv']+id+themoviedb['external_ids'],
		type: 'GET',
		dataType: 'json',
		cache: false,
		data: {"api_key": themoviedb['api_key']},
	})
	.done(function(data) {

		processExternalID(data,id)
		// console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}

function requestTVdb(tvdb_id, id){
	$.ajax({
		url: "/home/getseries",
		type: 'GET',
		dataType: 'json',
		data: {"id": tvdb_id},
	})
	.done(function(data) {
		processTVdb(data,id)
		console.log("success");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
}

