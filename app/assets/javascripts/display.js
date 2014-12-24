//javascript for the display view goes here

var dispFadeSpd = 500;
$(document).ready(function(){
	if($('#main-display').length>0){
		//console.log('this is the display view');
		//template views
		var tLine = _.template($('#line-template-display').html());
		
		//make sure the lines are sorted by sequence instead of index when read in
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});

		//waiting to get data vended in for characters

		//templating per line
		_.each(lines, function(q, i){
			if(q.visibility){
				$('#line-holder-display').append(
					tLine(q)
				);
			}
		});

		$('.line-display').first().fadeIn(dispFadeSpd, function(){
			$(this).addClass('shown-display');

		});




	}

});

//abstracted in crappy test function for now
function advance(seq){
	$('.shown-display').fadeOut(dispFadeSpd, function(){
		
		$(this).removeClass('shown-display');
		console.log('class-removed');
		$(_.find($('.line-display'), function(q){
			return parseInt($(q).attr('data-sequence'))==seq;
			})).fadeIn(dispFadeSpd, function(){
			$(this).addClass('shown-display');
		})
		
	})

}