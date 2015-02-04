//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
var targeted = 1;
var $targeted;
var current = 1;
var scrollSpd = 500;
var blackout = false;
var autoCommit = true;
var scrolling = false;

//jquery object to hold line elements
var $lines;

$(document).ready(function(){
	if($('#main-operator').length>0){
		//this function will universally commit the targeted line
		function seqPushed(d){
			//display logic if successful
			$('.current-operator').removeClass('current-operator');
			$targeted.addClass('current-operator');
			if(blackout){
				$('#blackout-icon-operator').addClass('blackout-off-operator');
				blackout=false;
			}
			current=$targeted.attr('data-sequence');
		}
		function commit(){
				//var $t = $('.target-operator');
				//post the current sequence identifier through AJAX
				if($targeted.attr('data-visibility')=="true"){
					$.ajax('/operator/pushTextSeq', {
						type:'POST',
						data: {
							seq:$targeted.attr('data-sequence'),
				            operator: operator
						},
						success:seqPushed,
						error:(function(){
							//put in better error handling here
							alert('Commit failed! Please check your connection.');
						}),
					});

				}

		}

		$('#main-operator').height($(window).innerHeight()+'px');

		//set the middlepoint
		//maybe tweak the 2.2?
		var mid = Math.round($(window).innerHeight()/2);

		//set the templates
		var tLine = _.template($('#line-template-operator').html());
		//make sure the lines are sorted by sequence instead of index when read in
		//native array.prototype.sort
		lines.sort(function(a, b){
			if(a.sequence < b.sequence){
				return -1;
			}
			if(a.sequence > b.sequence){
				return 1;
			}
			return 0;
		});

		//set up a universal named function that will return the number closest to the center using math.abs
	
		//refac further with custom named foreach with named eval function

		//	refac with native for loop
		// singleton is fine since this is a one-time execution
		//var lineCont = document.getElementById('line-holder-sub-operator');
		$lineCont = $('#line-holder-sub-operator');
		var il = lines.length-1;
		while(il>-1){
			var cl = lines[il];
			if(cl['element']['element_name'].length>0){
				cl['character'] = cl['element']['element_name'] + ':';
			}else{
				cl['character']=' ';
			}
			//this does the templating
			//lineCont.innerHTML=tLine(cl)+lineCont.innerHTML;
			//console.log(hString);
			$lineCont.prepend(tLine(cl));
			il--;
		}

		//clear the lines object now that it's been used
		lines=undefined;

		//store the new DOM lines inside of a jquery object
		$lines = $('.line-operator');
		//actually, would be good if lines were read into the array with sequence numbers for index vals?

		$targeted = $lines.first();
		$targeted.addClass('target-operator');
		var minSeq = Math.round($targeted.attr('data-sequence')); 
		var maxSeq = Math.round($targeted.last().attr('data-sequence'));
		$lines.each(function(){
			if($(this).attr('data-visibility')=="false"){
				$(this).addClass('line-non-visible-operator');
			}
		});
		//store an alias list
		function buildAlias(){
			//store each elevation and height in an object
			var la=[];
			//$lines.each(function(){
			for(var i = $lines.length-1; i>=0; i--){
				var line = $lines[i];
				var s = line['dataset']['sequence'];
				la[s] = {e:line['offsetTop'], h:line['offsetHeight']};
			};
			return la;
		}
		//build lAlias again on resize
		var lAlias = buildAlias();

		//this happens when you click the commit button
		$('#commit-button-operator').click(commit);

		//this sorts the stack for the line closest to middle
		function findMid(a, st){
			//define midpoint relative to holder
			var t = st+mid;
			var i = a.length-1;
			//set initial vals
			var cs = i;
			var ce = a[i]['e']+Math.round(a[i]['h']/2);
			var cd = Math.abs(ce-t);
			var ld = cd;
			while(i>0){
				//find the currently evaluated sequence's elevation minus midpoint
				var e=a[i]['e']+Math.round(a[i]['h']/2);
				//set a distance to beat based on absolute value
				var d = Math.abs(e-t);
				//if this distance is less than the one to beat
				if(d<cd){
					//then swap new vals
					cd = d;
					cs = i;
				}
				//if this distance is greater than the last then break
				if(d>ld){
					break;
				}
				ld=d;
				i--;
			}
			//return t;
			return cs;
		}
		var $lh = $('#line-holder-operator');
		$lh.scroll(function(){
			var updateInt = 300;
			//self destroying counter that updates the highlighting
			function advanceTarget(){
					//removed the targeted class
					$targeted.removeClass('target-operator');
					//get scrolltop
					var st = document.getElementById('line-holder-operator')['scrollTop'];
					//console.log('scrolltop is '+st);
					targeted = findMid(lAlias, st);
					//console.log(targeted);
					//now apply the target class to the correctly selected one

					//!!!this is where the sequence number and index don't match up
					//options
					//check sequence here... but it could get heavy
					// assume that sequence is index+1.. 99% right
					/*
					var ind = $lines.length-1;
					while(ind>0){
						if(parseInt($lines[ind]['dataset']['sequence'])==targeted-1){
							$targeted = $lines[ind];
							break;
						}
						ind--;
					}
					$targeted.addClass('targeted-operator');*/
					$targeted = $($lines[targeted-1]);
					console.log($targeted);
					$targeted.addClass('target-operator');

					//targeted = Math.round($lines.first().attr('data-sequence'));
					//destroy the counter
					window.counting=false;
			};
			if(!window.counting){
				window.counting = setTimeout(
				advanceTarget, updateInt);
			}

		});
		//this auto-scrolls to a desired element
		function aniScroll(el, c){
			$lh.animate({scrollTop: el['offsetTop'] +  Math.round(el['offsetHeight']/2) - mid}, scrollSpd, c);
		}
		//scroll to a line when it's clicked
		$('.line-operator').click(function(){
			aniScroll(this);
		});
		//action that rolls down preview and poplates is
		$('#preview-operator').click(function(){


			if($(this).attr('data-visible')=='false'){
				$(this).animate({left:'0px'}, 1000, function(){
					$(this).attr('data-visible', 'true');
					
					if($('#preview-operator iframe').attr('src')==""){
						$('#preview-operator iframe').attr('src', "/display/index?operator="+operator+"&view="+viewMode+"&work="+work);
					}
					
				});
			}else{
				$(this).animate({left:'-100%'}, 1000, function(){
					$(this).attr('data-visible', 'false');
				});
			}

		});
		//roll down the fast forward feature
		$('#fforward-operator').click(function(){
			if($(this).attr('data-visible')=='false'){
				$(this).animate({left:'0px'}, 1000, function(){
					$(this).attr('data-visible', 'true');
					$(this).find('input').first().focus();
				});
			}else{
				$(this).animate({left:'-100%'}, 1000, function(){
					$(this).attr('data-visible', 'false');
					$(this).find('input').first().blur();

				});
			}


		});

		//submit a line number
		$('#fforward-operator input').keypress(function(e){
			if(e.which == 13){
				//console.log($(this).val());
				var s = $(this).val();
				var l = _.find($('.line-operator'), function(q){
					return $(q).attr('data-sequence')==s;
				});
				//console.log(l);
				//this may be able to be abstracted to a single function

				if(l){
				var diff = ($('.target-operator').position().top - $(l).position().top)*1.0;
				$('#line-holder-operator').animate(
					{scrollTop:
						$('#line-holder-operator').scrollTop() - diff
					}, scrollSpd);
				}else{
					alert('Line ' + s + ' not found');
				}

				$('#fforward-operator').animate({left:'-100%'}, 1000, function(){
					$(this).attr('data-visible', 'false');
					var i = $(this).find('input').first();
					i.blur();
					i.val('');

				});

				return false;
			}
		});
		/*
		//need to debug this block
		$('#fforward-operator input').blur(function(){
				$('#fforward-operator').animate({left:'-100%'}, 500, function(){
					$(this).attr('data-visible', 'false');
					var i = $(this).find('input').first();
					i.blur();
					i.val('');

				});
			});
		*/
		function dispOff(d){
			console.log('display cleared');
			$('.current-operator').removeClass('current-operator');
			$('#blackout-icon-operator').toggleClass('blackout-off-operator');
			blackout=true;
		}
		function dispOn(d){
			console.log('display is back');
			var last = $.grep($('.line-operator'), function(n){
				return $(n).attr('data-sequence') == current;
			})[0];
			$(last).addClass('current-operator');
			//$('.current-operator').removeClass('current-operator');
			$('#blackout-icon-operator').toggleClass('blackout-off-operator');
			blackout=false;
		}
		//blackout the display
		$('#blackout-operator').click(function(){
			//console.log('blackout');
			if(!blackout){
				$.ajax('/operator/pushTextSeq', {
					type:'POST',
					data: {
						seq:0,
	          operator: operator
					},
					success:dispOff,
				});
			}else{
				$.ajax('/operator/pushTextSeq', {
					type:'POST',
					data: {
						seq:current,
	          operator: operator
					},
					success:dispOn,
				});
			}


		});
		$('#autocommit-operator').click(function(){
			if(autoCommit){
				autoCommit = false;
				console.log('autocommit off');

			}else{
				autoCommit = true;
				console.log('autocommit on');

			}
			console.log(this);
			$('#autocommit-icon-operator').toggleClass('autocommit-on-operator')
		});

		//single up and down buttons
		$('#up-button-operator').click(function(){
			if(!scrolling){
				if(targeted!=minSeq){
					scrolling=true;

					//console.log('scrolled');
					//this practice is not 100% sound
					//it relies on no gaps, no duplicates in sequence numbers
					aniScroll($lines[targeted-2], function(){
						if(autoCommit){ 
							commit(); 
						}
						targeted--; 
						console.log(targeted);
						scrolling=false;
						//targeted++;
					});
				}
			}	
		});
		$('#down-button-operator').click(function(){
			if(!scrolling){
				//doesn't scroll down on first line. need fix
				if(targeted!=maxSeq){
					scrolling=true;

					//console.log('scrolled');
					//this practice is not 100% sound
					//it relies on no gaps, no duplicates in sequence numbers

					aniScroll($lines[targeted], function(){
						if(autoCommit){ 
							commit(); 
						}
						targeted++; 
						console.log(targeted);
						scrolling=false;
						//targeted++;
					});
				}
			}
		});




	}

});
