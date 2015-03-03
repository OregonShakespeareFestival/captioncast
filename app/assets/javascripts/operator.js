//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var $targeted, $current;
var blackout = false;
var scrolling = false;
var opScrollSpd= 400;

var $lines; //jquery object to hold line elements
var lAlias;

$(document).ready(function(){
	if($('#main-operator').length>0){		
		//blackout screen and move to text sequence 0 when the operator is reset -!!!-

		//traverse operator after commit
		function seqPushed(d){
			//move animations into this function -!!!-
			$current.removeClass('current-operator');
			$targeted.addClass('current-operator');
			$current=$targeted;
			if(blackout){
				$('#blackout-icon-operator').addClass('blackout-off-operator');
				blackout=false;
			}
			console.log(d + ' pushed ');
		}

		//push text sequence to operator controller
		function commit(){
			if($targeted.attr('data-visibility')=="true"){
				$.ajax('/operator/pushTextSeq', {
					type:'POST',
					data: {
						seq:$targeted.attr('data-sequence'),
			            operator: operator
					},
					success:seqPushed,
					error:(function(){
						alert('Commit failed! Please check your connection.');
					})
				});
			}
		}

		//scrolls to desired element
		//can include a callback function
		function aniScroll(el, c){
			$('#line-holder-operator').stop().animate({scrollTop: el['offsetTop'] +  Math.round(el['offsetHeight']/2) - mid}, opScrollSpd, c);
		}

		



		//set the main operator's height to the height of the window
		//can do with with css by setting position:absolute top:0 bottom:0 -!!!-
		$('#main-operator').height($(window).innerHeight()+'px');

		//set the middlepoint
		//don't think this is needed once the find mid method is removed -!!!-
		var mid = Math.round($(window).innerHeight()/2);




		//TEMPLATING - all of this can eventually be moved to the controller -!!!-
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

		//ID for non-visual lines
		$lines.each(function(){
			if($(this).attr('data-visibility')=="false"){
				$(this).addClass('line-non-visible-operator');
			}
		});
		//END TEMPLATING - all of this can eventually be moved to the controller -!!!-




		$targeted = $lines.first();
		$targeted.addClass('target-operator');
		$current = $targeted;
		$current.addClass('current-operator');

		var minInd = 0; 
		var maxInd = $lines.length-1;

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

		//bind click handler to commit button
		$('#commit-button-operator').click(commit);

		//bind click handler to line operators
		$('.line-operator').click(function(){
			//remove target operator class
			$targeted.removeClass("target-operator");
			//set targeted to the line that was clicked on
			$targeted = $(this);
			//commit the change
			commit();
			//scroll the operator view to the new line
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
						//removed the targeted class
						$targeted.removeClass('target-operator');
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
