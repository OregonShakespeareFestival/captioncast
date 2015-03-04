//javascript for the display view goes here
var refresh = 50;
var dispFadeSpd = 400;
var MAXSCROLLDURATION = 1200;
var MINSCROLLDURATION = 500;
var displayScrollSpd = MAXSCROLLDURATION;
var $linesDisp;
var lastScrollMS = (new Date).getTime();


$(document).ready(function(){
	if($('#body-display-index').length>0){
		var current=0;

		//make sure the lines are sorted by sequence instead of index when read in
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});
		function buildLinesDisp($container){
			var il = 0;
			var ll = lines.length; 
			var lc, cc;
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

		if($('#multi-flag-display').length<=0){
			$lineCont = $('#line-holder-display');
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
			//when the first line fade in it sets off the preiodic ajax scrape
			//for now we're just grabbing a random number but soon it will be the number supplied by the operator
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
		}else{
			$('#shade-multi').css('display', 'none');
			//this is specific JS for the multi-line view
			console.log('welcome to multi-line mode');
			// //template views
			var tLine = _.template($('#line-template-display-multi').html());

			$lineCont = $('#line-holder-display-multi');


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
			$linesDisp = $('.line-display-multi');


			//set first interval
			function heartbeat(){
				var bottomPad = 65;
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
								var now = (new Date).getTime();
								displayScrollSpd = Math.max(MINSCROLLDURATION, (Math.min(MAXSCROLLDURATION, (now - lastScrollMS))));
								lastScrollMS = now;
								console.log(displayScrollSpd);
								if(current!==0){
									$('#shade-multi').fadeOut(dispFadeSpd);
									var newElem = _.find($linesDisp, function(q){
											return parseInt($(q).attr('data-sequence'))==j;
									});
									$('#body-display-index').stop().animate({scrollTop:$(newElem).position().top-$(window).height()/2+$(newElem).height()+bottomPad}, displayScrollSpd);
									//remove the focus class
									$('.focus-multi').removeClass('focus-multi');
									//console.log('class-removed');

									$(newElem).addClass('focus-multi');
								}else{
								//TODO: blackout
								}

							}
							setTimeout(function(){
								heartbeat();
								}, refresh);
							
						}),
				});
			}
			heartbeat();





		}
		$('#shade-loading-display').fadeOut(1000, function(){});

	}


});
