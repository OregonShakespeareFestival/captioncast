//javascript for the display view goes here
var refresh = 500;
var dispFadeSpd = 400;
var scrollSpd = 800;
$(document).ready(function(){
	if($('#multi-flag-display').length<=0){

	//if($('#main-display').length>0){
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

		//waiting to get data vended in for characters

		//templating per line
		_.each(lines, function(q, i){
			//this is a temporary scrub in of fixture characters
			//q.character = 'Character';
			//console.log(q.character);
			//append character name with color
			if(q.element.element_name.length>0){
				//console.log('I seeee you');
				q.character = q.element.element_name + ':';
			}else{
				q.character=' ';
			}
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


	//end of original block
	//}
	}else{
		$('#shade-multi').css('display', 'none');

		//this is specific JS for the multi-line view
		console.log('welcome to multi-line mode');
		//console.log('this is the display view');
		//template views
		var tLine = _.template($('#line-template-display-multi').html());

		//make sure the lines are sorted by sequence instead of index when read in
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});


		//seed sequence #0 with a blank line
		$('#line-holder-display-multi').append(
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

		//waiting to get data vended in for characters
		//$('#line-holder-display-multi').append('<div id="buffer-top-display-multi"></div>');

		//templating per line
		_.each(lines, function(q, i){
			//this is a temporary scrub in of fixture characters
			//q.character = 'Character';
			//console.log(q.character);
			//append character name with color
			if(q.element.element_name.length>0){
				//console.log('I seeee you');
				q.character = q.element.element_name + ':';
			}else{
				q.character=' ';
			}
			if(q.visibility){
				$('#line-holder-display-multi').append(
					tLine(q)
				);
			}
		});
		//$('#line-holder-display-multi').append('<div id="buffer-bottom-display-multi"></div>');

		//$('.line-display-multi').addClass('shown-display');
		//$('.line-display-multi').addClass('blur-multi');
		//when the first line fade in it sets off the preiodic ajax scrape
		//for now we're just grabbing a random number but soon it will be the number supplied by the operator

		//set first interval
		function heartbeat(){
			var bottomPad = 30;
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

							if(current!==0){
								$('#shade-multi').fadeOut(dispFadeSpd);
								var newElem = _.find($('.line-display-multi'), function(q){
										return parseInt($(q).attr('data-sequence'))==j;
								});
							/*
								//animate the scroll
								var diff = ($('#line-display-0').position().top - $(newElem).position().top)*1.0;
								$('#line-holder-display-multi').animate(
									{scrollTop:
										$('#line-holder-display-multi').scrollTop() - diff
								}, scrollSpd);
							*/
								//$('#body-index-display').animate({scrollTop:$(newElem).position().top-$(window).height()/2-$(newElem).height()/2});
								//$('#body-index-display').animate({scrollTop:$(newElem).position().top-$(newElem).height()/2});
								$('#body-index-display').animate({scrollTop:$(newElem).position().top-$(window).height()/2+$(newElem).height()+bottomPad});
								//$('.shown-display').fadeOut(dispFadeSpd, function(){
								//remove the focus class
								$('.focus-multi').removeClass('focus-multi');
								//console.log('class-removed');

								$(newElem).addClass('focus-multi');
										//$(this).addClass('shown-display');
								setTimeout(function(){
									heartbeat();
								}, refresh);
							}else{
								$('#shade-multi').fadeIn(dispFadeSpd);
								setTimeout(function(){
									heartbeat();
									}, refresh);
							}


								//});

						}else{
							setTimeout(function(){
								heartbeat();
								}, refresh);
						}


					}),
			});
		}
		heartbeat();





	}

});
