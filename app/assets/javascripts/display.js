//javascript for the display view goes here
var refresh = 5000;
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
		//when the first line fade in it sets off the preiodic ajax scrape
		//for now we're just grabbing a random number but soon it will be the number supplied by the operator
		$('.line-display').first().fadeIn(dispFadeSpd, function(){
			$(this).addClass('shown-display');
			//set first interval
			function adv(){
				//ajax goes here next timeout
				$.ajax('/display/current', 
					{
						success:(function(j){
							console.log('sequence scraped ' + j);

							if(current!=j){
								//console.log(j);
								current=j;
								
								$('.shown-display').fadeOut(dispFadeSpd, function(){
									$(this).removeClass('shown-display');
									//console.log('class-removed');
									$(_.find($('.line-display'), function(q){
										return parseInt($(q).attr('data-sequence'))==j;
										})).fadeIn(dispFadeSpd, function(){
											$(this).addClass('shown-display');
											setTimeout(function(){
												adv();
											}, refresh);

										});

									
								});
								
							}
						}),
				});
			}
			adv();
		});




	}

});
/*
//abstracted in crappy test function for now
function advance(seq){
	//current var is global in another section of script
	console.log(current + 'and' + seq);
	if(current!=seq){
		current=seq;
		$('.shown-display').fadeOut(dispFadeSpd, function(){
			$(this).removeClass('shown-display');
			//console.log('class-removed');
			$(_.find($('.line-display'), function(q){
				return parseInt($(q).attr('data-sequence'))==seq;
				})).fadeIn(dispFadeSpd, function(){
				$(this).addClass('shown-display');
			})
			
		})
	}

}
*/