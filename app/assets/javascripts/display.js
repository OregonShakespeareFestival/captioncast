//global variable for overall scale of lines
//this represents the percentage sizing of the display font
//may or may not end up using this.
var scale = 900;


//javascript for the display view goes here

//make the refresh rate as high as can be tolerated
var refresh = 50;

//this is how fast the screen blacks out
var dispFadeSpd = 400;

//this is how quickly the next line scrolls
var displayScrollSpd = 500;


var $linesDisp, $b, inc, curLin, $blackOutCov;

//this function moves to any given line at any given increment
//accepts the name of the element to be scrolled, line height increment, and the current line
$(document).ready(function(){
	if($('#body-display-index, #body-display-multi').length>0){
		//set the element to be scrolled
		$b = $('#body-display-index');
		//set the blackout cover
		$blackOutCov = $('#shade-multi');

		//make sure the lines are sorted by sequence instead of index when read in
		//this can likely be done more efficiently in Rails ActiveRecord + ActionView
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});

		//this function modified our lines and turns them into DOM objects
		function buildLinesDisp($container){
			var il = 0;
			var ll = lines.length;
			var lc, cc;
			//figure out if we're going to include character name based on who said last line
			//--!!!-- this needs to account properly for blanklines
			while(il<ll){
				if(lines[il]['visibility']){
					var cl = lines[il];
					cc = cl['element']['element_name'];
					if(cc.length>0&&cc!=lc){
						cl['character'] = cl['element']['element_name'] + ':';
						lc = cc;
					}else{
						cl['character']=' ';
					}
					$container.append(tLine(cl));
				}
				il++;
			}
		}

		//let's just disable single line view for now
		//clearly there's little demand for it at the moment

		//if we're in single line view...
		if($('#multi-flag-display').length<=0){
		/*	$lineCont = $('#line-holder-display');
			// template views
			var tLine = _.template($('#line-template-display').html());
			//seed sequence #0 with a blank line
			$lineCont.append(
				tLine({
					"character":'',
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

			//build the line dom
			buildLinesDisp($lineCont);
			$linesDisp = $('.line-display');
			$linesDisp.first().fadeIn(dispFadeSpd, function(){
				$(this).addClass('shown-display');
				//set first interval
				function heartbeat(){
					//ajax goes here next timeout
					$.ajax('/display/current',
				  	{
							data: {operator: operator},
					  	dataType: 'json',
							success:(function(j){
								console.log('sequence scraped ' + j);

								if(current!=j){
									//console.log(j);
									current=j;
									$('.shown-display').fadeOut(dispFadeSpd, function(){
										$(this).removeClass('shown-display');
										//console.log('class-removed');
										$(_.find($linesDisp, function(q){
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


		//end of original block
		//}
		*/


		//if we're using multi-line view
		}else{
			//hide the initial cover the display view
			//$('#shade-multi').css('display', 'none');

			//set the templating function
			var tLine = _.template($('#line-template-display-multi').html());

			//set the line container
			$lineCont = $('#line-holder-display-multi');

			//seed with a blank line first
			// !!! not sure if we need this anymore
			$lineCont.append(
				tLine({
					"character":'',
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

			//build the line dom
			buildLinesDisp($lineCont);

			//set increment for line up/down
			//the increment is based on the line height in the CSS, parsed to a float
			//!!! - this number is not precise enough to facilitate scrolling through an extended script
			//!!! - We may need a feature later on that "corrects" the inaccuracy
			inc = parseFloat($('.line-display-multi').css('line-height'));
			//store the container name in a var
			$linesDisp = $('.line-display-multi');


			//heartbeat is a recursive function linked to the success of an ajax poll
			function heartbeat(){
				//ajax goes here next timeout
				$.ajax('/display/current', {
					data: {operator: operator},
					dataType: 'json',
					success:linePulled,
					error:(function(e){
						console.log('error: polling failed');
					})
				});

				//ajax for checkout for blackout
				$.ajax('/display/blackout', {
					data: { operator: operator },
					dataType: 'json',
					success: blackedOut,
					error:(function(e) {
						console.log('error: polling for blackout failed');
					})
				});
			}
			function linePulled(j){
				console.log('line scraped ' + j);
				//if(current!=j){

				//if the line has changed
				if(curLin!=j) {
					curLin=j;

					//most importantly
					//move view to the next line
					$b.stop();
					$b.animate({scrollTop:inc*curLin}, displayScrollSpd);
				}

				//set the next heartbeat
				setTimeout(function(){
					heartbeat();
				}, refresh);
			}
			function blackedOut(b) {
				console.log('blackout toggled: ' + b);
				if(b == 1)
					$blackOutCov.fadeIn(dispFadeSpd);
				else
					$blackOutCov.fadeOut(dispFadeSpd);
			}
			//start the heartbeat for the first time
			heartbeat();





		}

		//when everything is done processing, we fade off the loading message
		//everything above this is sync so this goes at the very bottom of our code
		//!!! would be great if this had an animated throbber
		$('#shade-loading-display').fadeOut(1000, function(){});

	}


});
