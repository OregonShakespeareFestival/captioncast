//= require spin
//= require jquery.spin
$(document).ready(function(){

	$("#submit_upload").click(function(){
		$("#upload_notice").spin({
		  lines: 12, // The number of lines to draw
		  length: 7, // The length of each line
		  width: 9, // The line thickness
		  radius: 30, // The radius of the inner circle
		  color: '#000', // #rgb or #rrggbb
		  speed: 1, // Rounds per second
		  trail: 60, // Afterglow percentage
		  shadow: false // Whether to render a shadow
		});
	});
	
});