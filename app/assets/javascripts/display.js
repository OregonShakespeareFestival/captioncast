//javascript for the display view goes here
var refresh = 50;
var dispFadeSpd = 400;
var MAXSCROLLDURATION = 700;
var MINSCROLLDURATION = 500;
var displayScrollSpd = MAXSCROLLDURATION;
var $linesDisp;
var blackout = 0;

var lastScrollMS = (new Date).getTime();

$(document).ready(function(){
	if($('#body-display-index').length>0){
		//TEMPLATING - this can be moved into the controller eventually -!!!-
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
		//END TEMPLATING - this can be moved into the controller eventually -!!!-

		//if single
		if($('#multi-flag-display').length<=0) {
			//MORE TEMPLATING - can be moved to the controller -!!!-
			$lineCont = $('#line-holder-display');
			var tLine = _.template($('#line-template-display').html());
			buildLinesDisp($lineCont);
			//END MORE TEMPLATING - can be moved to the controller -!!!-

			$('.line-display').first().addClass('shown-display');

			function singleHeartbeat(){
				$.ajax('/display/current', {
					data: { operator: operator },
					dataType: 'json',
					success:(function(j) {
						console.log('sequence scraped ' + j.pos + ' blackout: ' + j.blackout);
						//if the data sequence changed
						if($('.shown-display').attr('data-sequence') != j.pos) {
							//calculate scroll speed
							var now = (new Date).getTime();
							displayScrollSpd = Math.max(MINSCROLLDURATION, (Math.min(MAXSCROLLDURATION, (now - lastScrollMS))));
							lastScrollMS = now;
							console.log(displayScrollSpd);
							//fade out the shown display
							$('.shown-display').stop().fadeOut(dispFadeSpd);
							//remove the shown display class
							$('.shown-display').removeClass('.shown-display');
							//add the focus class to the new line
							$('#line-display-'+j.pos).addClass('shown-display');
							//animate scroll to the changed data sequence
							$('.shown-display').stop().fadeIn(dispFadeSpd);
						}
						//if the blackout changed
						if(blackout != j.blackout) {
							$('#shade-multi').stop().fadeToggle(dispFadeSpd);
							blackout = j.blackout;
						}

						//set timer to repeat the heartbeat
						setTimeout(function() {
							heartbeat();
						}, refresh);
					}),
				});
			}

			singleHeartbeat();
		//if multi
		} else {
			//MORE TEMPLATING - can be moved to the controller -!!!-
			var tLine = _.template($('#line-template-display-multi').html());
			$lineCont = $('#line-holder-display-multi');
			buildLinesDisp($lineCont);
			//END MORE TEMPLATING - can be moved to the controller -!!!-

			$('.line-display-multi').first().addClass('focus-multi');			

			function multiHeartbeat(){
				$.ajax('/display/current', {
					data: { operator: operator },
					dataType: 'json',
					success:(function(j) {
						console.log('sequence scraped ' + j.pos + ' blackout: ' + j.blackout);
						//if the data sequence changed
						if($('.focus-multi').attr('data-sequence') != j.pos) {
							//calculate scroll speed
							var now = (new Date).getTime();
							displayScrollSpd = Math.max(MINSCROLLDURATION, (Math.min(MAXSCROLLDURATION, (now - lastScrollMS))));
							lastScrollMS = now;
							console.log(displayScrollSpd);
							//animate scroll to the changed data sequence
							$('#body-display-index').stop().animate({scrollTop:$('#line-display-'+j.pos).offset().top-$(window).height()+$('#line-display-'+j.pos).outerHeight()}, displayScrollSpd, "linear");
							//remove the focus class
							$('.focus-multi').removeClass('focus-multi');
							//add the focus class to the new line
							$('#line-display-'+j.pos).addClass('focus-multi');	
						}
						//if the blackout changed
						if(blackout != j.blackout) {
							$('#shade-multi').stop().fadeToggle(dispFadeSpd);
							blackout = j.blackout;
						}

						//set timer to repeat the heartbeat
						setTimeout(function() {
							heartbeat();
						}, refresh);
					}),
				});
			}

			multiHeartbeat();
		}

		$('#shade-loading-display').fadeOut(1000, function(){});
	}
});
