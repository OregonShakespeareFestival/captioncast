//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
var targeted = 0;
var $targeted, $current;
var blackout = false;
var scrolling = false;
var opScrollSpd= 400;

//jquery object to hold line elements
var $lines;
var lAlias;
$(document).ready(function(){
	if($('#main-operator').length>0){
		var currentOp = 0;
		//whenever the operator is restarted black out the screen -- can abstract this
		$.ajax('/operator/pushTextSeq', {
				type:'POST',
				data: {
					seq:0,
			        operator: operator
				},
			success:dispOff,
		});

		//this function will universally commit the targeted line
		function seqPushed(d){
			//display logic if successful
			if($current){
				$current.removeClass('current-operator');
			}
			$targeted.addClass('current-operator');
			$current=$targeted;
			if(blackout){
				$('#blackout-icon-operator').addClass('blackout-off-operator');
				blackout=false;
			}
			currentOp=targeted;
			console.log(d + ' pushed ' + 'for index ' + currentOp );
		}
		function commit(){
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

	
		$lineCont = $('#line-holder-sub-operator');
		// var il = lines.length-1;
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
				$lineCont.append(tLine(cl));
			}
			il++;
		}

		//clear the lines object now that it's been used
		lines=undefined;

		//store the new DOM lines inside of a jquery object
		$lines = $('.line-operator');
		//actually, would be good if lines were read into the array with sequence numbers for index vals?

		$targeted = $lines.first();
		$targeted.addClass('target-operator');
		var minInd = 0; 
		var maxInd = $lines.length-1;
		//ID for non-visual lines
		$lines.each(function(){
			if($(this).attr('data-visibility')=="false"){
				$(this).addClass('line-non-visible-operator');
			}
		});
		function boolSet(str){
			if(str=='true'){
				return 1;
			}else{
				return 0;
			}
		}
		//this is a very lean way to store frequently evaluated values for each line
		function buildAlias(){
			var la=[];
			for(var i = $lines.length-1; i>=0; i--){
				var line = $lines[i];
				//var s = line['dataset']['sequence'];
				la[i] = [line['offsetTop'], line['offsetHeight'], boolSet(line['dataset']['visibility'])];
			};
			return la;
		}
		//build lAlias again on resize
		lAlias = buildAlias();

		//this happens when you click the commit button
		$('#commit-button-operator').click(commit);

		//this is a lean function that sorts the stack for the line closest to middle
		function findMid(a, st){
			//define midpoint relative to holder
			var t = st+mid;
			var i = a.length-1;
			//set initial vals
			var ci = i;
			var ce = a[i][0]+Math.round(a[i][1]/2);
			var cd = Math.abs(ce-t);
			var ld = cd;
			while(i>-1){
				//find the currently evaluated sequence's elevation minus midpoint
				var e=a[i][0]+Math.round(a[i][1]/2);
				//set a distance to beat based on absolute value
				var d = Math.abs(e-t);
				//set the visibility
				var v = a[i][2];
				//if this distance is less than the one to beat and visible
				if(d<cd&&v==1){
					//then swap new vals
					cd = d;
					ci = i;
				}
				//if this distance is greater than the last and visible then break
				if(d>ld&&v==1){
					break;
				}
				ld=d;
				i--;
			}
			return ci;
		}
		var $lh = $('#line-holder-operator');
		//everytime the operator is scrolled, target a new line
		// $lh.scroll(function(){
		// 	var updateInt = 300;
		// 	//self destroying counter that updates the highlighting
		// 	function advanceTarget(){
		// 			//removed the targeted class
		// 			$targeted.removeClass('target-operator');
		// 			//get scrolltop
		// 			var st = document.getElementById('line-holder-operator')['scrollTop'];
		// 			targeted = findMid(lAlias, st);
		// 			$targeted = $($lines[targeted]);
		// 			$targeted.addClass('target-operator');

		// 			//destroy the counter
		// 			window.counting=false;
		// 			commit();
		// 	};
		// 	if(!window.counting){
		// 		window.counting = setTimeout(
		// 		advanceTarget, updateInt);
		// 	}

		// });
		//this auto-scrolls to a desired element
		function aniScroll(el, c){
			$lh.animate({scrollTop: el['offsetTop'] +  Math.round(el['offsetHeight']/2) - mid}, opScrollSpd, c);
		}
		//scroll to a line when it's clicked
		$('.line-operator').click(function(){
			aniScroll(this, function() {
				//removed the targeted class
				$targeted.removeClass('target-operator');
				//get scrolltop
				var st = document.getElementById('line-holder-operator')['scrollTop'];
				targeted = findMid(lAlias, st);
				$targeted = $($lines[targeted]);
				$targeted.addClass('target-operator');

				//destroy the counter
				window.counting=false;
				//commit();
			});
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
		//old js for "skip to number" feature 
		//let's hide this and see if anybody cares
		//front-end features are like teeth: ignore them and they will go away

		/* 
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
				//this may be able to be abstracted to a single function

				if(l){
				var diff = ($('.target-operator').position().top - $(l).position().top)*1.0;
				$('#line-holder-operator').animate(
					{scrollTop:
						$('#line-holder-operator').scrollTop() - diff
					}, opScrollSpd);
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
				return $(n).attr('data-sequence') == currentOp;
			})[0];
			$(last).addClass('current-operator');
			$('#blackout-icon-operator').toggleClass('blackout-off-operator');
			blackout=false;
		}
		//blackout the display
		$('#blackout-operator').click(function(){
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
						seq:currentOp,
	          operator: operator
					},
					success:dispOn,
				});
			}


		});

		//single up and down buttons
		$('#up-button-operator').click(function(){
			if(!scrolling){
				if(targeted!=minInd){
					targeted--;
					while(!lAlias[targeted][2]&&targeted>minInd){
						targeted--;
					}
 				
					aniScroll($lines[targeted], function(){
						//console.log(targeted);
						scrolling=false;
					});
				}
			}	
		});
		$('#down-button-operator').click(function(){
			if(!scrolling){
				if(targeted!=maxInd){
					scrolling=true;
					//removed the targeted class
					$targeted.removeClass('target-operator');
					targeted++;
					while(!lAlias[targeted][2]&&targeted<maxInd){
						targeted++;
					}
					aniScroll($lines[targeted], function(){
						scrolling=false;
						//get scrolltop
						var st = document.getElementById('line-holder-operator')['scrollTop'];
						targeted = findMid(lAlias, st);
						$targeted = $($lines[targeted]);
						$targeted.addClass('target-operator');

						//destroy the counter
						window.counting=false;
						commit();
					});
				}
			}
		});



		$('#shade-loading-operator').fadeOut(1000, function(){});

	}

});
