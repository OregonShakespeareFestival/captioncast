//javascript for the display view goes here

//need a remapping function to predict character limites from scaling
function remap(v, min, max, nMin, nMax){
	return nMin + (nMax - nMin) * (v - min) / (max - min);
}

var refresh = 20;
var dispFadeSpd = 40;
var displayScrollSpd = 500;
var $linesDisp;

//set a general scale number to go by
//900 represents 900% font size and will use this to parse and divide text elements globally
var scale = 900;
//30 characters fill the appropriate width of a 1080P screen at 900%
//50 characters fill the appropriate width of a 1080P screen at 600%
//will want to find the next space inside of 30 characters and split lines there
//var charLim = Math.round(remap(scale, 600, 900, 50, 30));
var $b, inc, cur;
//make the page move at any given increment
//increment with a negative to move down
function move($el, incr){
	cur+=incr;
	$el.animate({scrollTop:cur}, displayScrollSpd);
}
$(document).ready(function(){

	if($('#body-index-display').length>0){
		$b = $('#body-index-display');
		cur = $('#body-index-display').scrollTop();

		var current=0;

		//make sure the lines are sorted by sequence instead of index when read in
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});
/*
		//split lines by char limit here?
		var i = lines.length-1;
		while(i>=0){
			console.log(lines[i]['content_text']);
			var c = lines[i]['content_text'];
			var arr = [];
			while(c.length>0){
				arr.push(c.substr(0,charLim));

			}
			lines[i]['content_arr']=arr;

			i--;
		}
		*/

		function buildLinesDisp($container){



			var il = 0;
			var ll = lines.length; 
			var lc, cc;
			//figure out if we're going to include character name based on who said last line
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
		//if we're in single line view...
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

		//if we're using multi-line view
		}else{

			$('#shade-multi').css('display', 'none');
			//this is specific JS for the multi-line view
			//console.log('welcome to multi-line mode');

			//redivide lines


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

			//set increment for line up/down
			inc = parseFloat($('.line-display-multi').css('line-height'));
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

								if(current!==0){
									$('#shade-multi').fadeOut(dispFadeSpd);
									var newElem = _.find($linesDisp, function(q){
											return parseInt($(q).attr('data-sequence'))==j;
									});
									$('#body-index-display').animate({scrollTop:$(newElem).position().top-$(window).height()/2+$(newElem).height()+bottomPad}, displayScrollSpd);
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
		$('#shade-loading-display').fadeOut(1000, function(){});

	}


});
