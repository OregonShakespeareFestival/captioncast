//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
var targeted = 1;
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
		function commit(){
				var $t = $('.target-operator');
				//post the current sequence identifier through AJAX
				if($t.attr('data-visibility')=="true"){
					$.ajax('/operator/pushTextSeq', {
						type:'POST',
						data: {
							seq:$t.attr('data-sequence'),
				            operator: operator
						},
						success:(function(d){
							//display logic if successful
							$('.current-operator').removeClass('current-operator');
							$t.addClass('current-operator');
							if(blackout){
								$('#blackout-icon-operator').addClass('blackout-off-operator');
								blackout=false;
							}
							current=$t.attr('data-sequence');
						}),
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
		var mid = parseInt($(window).innerHeight()/2);

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

		//templating per line
		/*_.each(lines, function(q, i){
			if(q.element.element_name.length>0){
				q.character = q.element.element_name + ':';
			}else{
				q.character=' ';
			}
			$('#line-holder-sub-operator').append(
				tLine(q)
			);
			$('.line-operator').first().addClass('target-operator');
			$('.line-operator').each(function(){
				if($(this).attr('data-visibility')=="false"){
					$(this).addClass('line-non-visible-operator');
				}
			});
		});*/

		
		//refac further with custom named foreach with named eval function

		//	refac with native for loop
		// singleton is fine since this is a one-time execution
		lines.forEach(function(q){
			if(q.element.element_name.length>0){
				q.character = q.element.element_name + ':';
			}else{
				q.character=' ';
			}
			//this does the templating
			document.getElementById('line-holder-sub-operator').innerHTML+=tLine(q);
		});
		//store the lines inside of a jquery object
		$lines = $('.line-operator');
		$lines.first().addClass('target-operator');
		$lines.each(function(){
			if($(this).attr('data-visibility')=="false"){
				$(this).addClass('line-non-visible-operator');
			}
		});
		//loop again and calculate the scroll top value and store in new data-height attr

		//actually can we just have a simple alias/pairing
		//use an indexed array
		//pair sequences with vertical locations
		/*
		var lAlias=[];
		$lines.each(function(){
			//this.attr('data-height', this.position().top);

			lAlias[$(this).attr('data-sequence')] = this.offsetTop;
		});
		*/
		//store an alias list
		function buildAlias(){
			//store each elevation and height in an object
			var la=[];
			//$lines.each(function(){
			for(var i = $lines.length-1; i>=0; i--){
				var line = $lines[i];
				//var s = $(this).attr('data-sequence');
				var s = line['dataset']['sequence'];
				la[s] = {e:line['offsetTop'], h:line['offsetHeight']};
			};
			return la;
		}
		//build lAlias again on resize
		var lAlias = buildAlias();

		//this happens when you click the commit button
		$('#commit-button-operator').click(commit);

		//scrolling target feature
		//!!!this is the heaviest and needs refac big time
		//use named function for sorting
		//eventually shift all of this to the top to minimize hoisting
		//make this a singleton at the risk of being non-responsive

		//ARGH! scrap this! write an even leaner function, please
		/*
		function sortHeight(a, b){
			//there's a problem i how offset works
			//a.getAttribute('data-height');
			var an = Math.abs(a.offsetTop-mid);
			var bn = Math.abs(b.offsetTop-mid);
			if(an>bn){
				return 1;
			}
			if(an<bn){
				return -1;
			}
			return 0;
		}*/

		//really... get on that. leaner function, now, please
		/*function findCenter($a, st){
			//scrolltop is st
			//set first closest number by subtracting scrolltop
			var c = $a[1];
			//set array length
			var l = $a.length;
			//loop through array
			for(var i=1; i<l; i++){
				//if entry i even exists to begin with
				//if math abs of current is less than math abs of t then replace t

				//check to see if this perfs better
				//if math abs of next is more than the last then break?

			}
			//return the top
			return t;
		}*/
		function findMid(a, st){
			//define midpoint relative to holder
			//var t = st+mid;
			var t = st;
			var i = a.length-1;
			//set initial vals
			var cs = i;
			var ce = a[i]['e'];
			var cd = Math.abs(ce-t);
			var ld = cd;
			while(i>0){
				//find the currently evaluated sequence's elevation minus midpoint
				var e=a[i]['e'];
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
		/*
		function forEach(a, c){
			var l = a.length;
			for(var i=0; i<l; i++){
				c(a[i], i);
			}
		};
		*/
		$('#line-holder-operator').scroll(function(){
			var updateInt = 300;
			//self destroying counter that updates the highlighting
			function advanceTarget(){
					//removed the targeted class
					$('.target-operator').removeClass('target-operator');
					//var mid = $(window).innerHeight()/2.2;
					//!! heaviest call shows in profiling
					/*var l = _.sortBy($('#line-holder-operator div.line-operator'), function(q){
						return Math.abs($(q).offset().top-mid);
					});*/



					//this needs to be leaner still!
					//$lines.sort(sortHeight);
					//get scrolltop
					var st = $('#line-holder-operator')[0]['scrollTop'];
					console.log('scrolltop is '+st);
					targeted = findMid(lAlias, st);
					console.log(targeted);
					//now apply the target class to the correctly selected one
					$($lines[targeted]).addClass('target-operator');
					//$lines.first().addClass('target-operator');
					//targeted = parseInt($lines.first().attr('data-sequence'));
					//destroy the counter
					window.counting=false;
			};
			if(!window.counting){
				window.counting = setTimeout(
				advanceTarget, updateInt);
			}

		});
		//click the line I want feature
		$('.line-operator').click(function(){

			//this can be made much much leaner as well.
			var diff = ($('.target-operator').position().top - $(this).position().top)*1.0;
			$('#line-holder-operator').animate(
				{scrollTop:
					$('#line-holder-operator').scrollTop() - diff
				}, scrollSpd);
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
					success:(function(d){
						console.log('display cleared');
						$('.current-operator').removeClass('current-operator');
						$('#blackout-icon-operator').toggleClass('blackout-off-operator');
						blackout=true;
					}),
				});
			}else{
				$.ajax('/operator/pushTextSeq', {
					type:'POST',
					data: {
						seq:current,
	          operator: operator
					},
					success:(function(d){
						console.log('display is back');
						var last = $.grep($('.line-operator'), function(n){
							return $(n).attr('data-sequence') == current;
						})[0];
						$(last).addClass('current-operator');
						//$('.current-operator').removeClass('current-operator');
						$('#blackout-icon-operator').toggleClass('blackout-off-operator');
						blackout=false;
					}),
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
				scrolling=true;
				var prevNum = parseInt($('.target-operator').first().attr('data-sequence'))-1;
				var firstNum = parseInt($('.line-operator').first().attr('data-sequence'));
				var finalNum = parseInt($('.line-operator').last().attr('data-sequence'));
				console.log(prevNum);
				if(prevNum >= firstNum && prevNum < finalNum){
					var prevTar;
					while(typeof prevTar==='undefined' && prevNum >= firstNum){
						prevTar = $.grep($('.line-operator'), function(n){
							return $(n).attr('data-sequence') == prevNum;
						})[0];
						prevNum--;
						console.log(prevTar);
					}
					var diff = ($('.target-operator').position().top - $(prevTar).position().top)*1.0;
					$('#line-holder-operator').animate(
						{scrollTop:
							$('#line-holder-operator').scrollTop() - diff
						}, scrollSpd, function(){
							if(autoCommit){
								commit();
							}

							scrolling=false;
						});
				}
			}	
		});
		$('#down-button-operator').click(function(){
			if(!scrolling){
				scrolling=true;
				var nextNum = parseInt($('.target-operator').first().attr('data-sequence'))+1;
				var firstNum = parseInt($('.line-operator').first().attr('data-sequence'));
				var finalNum = parseInt($('.line-operator').last().attr('data-sequence'));
				if(nextNum <= finalNum && nextNum >= firstNum){
					var nextTar;
					while(typeof nextTar==='undefined' && nextNum < finalNum){
						nextTar = $.grep($('.line-operator'), function(n){
							return $(n).attr('data-sequence') == nextNum;
						})[0];
						nextNum++;
					}
					//console.log(nextTar);
					var diff = ($('.target-operator').position().top - $(nextTar).position().top)*1.0;
					$('#line-holder-operator').animate(
						{scrollTop:
							$('#line-holder-operator').scrollTop() - diff
						}, scrollSpd, function(){
							if(autoCommit){
								commit();
							}

							scrolling=false
						});
				}
			}
		});




	}

});
