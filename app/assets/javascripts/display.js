//javascript for the display view goes here
var refresh = 2000;
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


		//seed sequence #0 with a blank line
		$('#line-holder-display').append(
			tLine({
			    "id": 0,
			    "sequence": 0,
			    "content_type": "Non-Dialogue",
			    "content_text": " ",
			    "color": null,
			    "visibility": false,
			    "created_at": " ",
			    "updated_at": " "
				})
			);

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
			function heartbeat(){
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
												heartbeat();
											}, refresh);
											
										});

									
								});
								
							}else{
								setTimeout(function(){
									heartbeat();
									}, refresh);
							}


						}),
				});
			}
			heartbeat();
		});




	}

});
