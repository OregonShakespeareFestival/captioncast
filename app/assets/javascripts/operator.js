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

$(document).ready(function(){
	if($('#main-operator').length>0){		
		//blackout screen and move to text sequence 0 when the operator is reset -!!!-


		//scrolls to desired element
		//can include a callback function
		function aniScroll(el, c){
			$('#line-holder-operator').stop().animate({scrollTop: el['offsetTop'] +  Math.round(el['offsetHeight']/2) - mid}, opScrollSpd, c);
		}

		//traverse operator after commit
		function seqPushed(){
			aniScroll($targeted.get(), function() {
				$current.removeClass('current-operator');
				$current.removeClass('target-operator');
				$current=$targeted;
				$current.addClass('current-operator');
				$current.addClass('target-operator')
			});
			//abstract this -!!!-
			if(blackout){
				$('#blackout-icon-operator').addClass('blackout-off-operator');
				blackout=false;
			}
			console.log(d + ' pushed ');
		}

		//push text sequence to operator controller
		function commit(el){
			if($targeted.attr('data-visibility')=="true"){
				$.ajax('/operator/pushTextSeq', {
					type:'POST',
					data: {
						seq:$targeted.attr('data-sequence'),
			            operator: operator
					},
					success:seqPushed,
					error:(function(){
						$targeted=$current;
						alert('Commit failed! Please check your connection.');
					})
				});
			}
		}

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




		$targeted = $('.line-operator').first();
		$targeted.addClass('target-operator');
		$current = $targeted;
		$current.addClass('current-operator');

		//bind click handler to commit button
		$('#commit-button-operator').click(commit);

		//bind click handler to line operators
		$('.line-operator').click(function(){
			//remove target operator class
			$targeted.removeClass('target-operator');
			//set targeted to the line that was clicked on
			$targeted = $(this);
			//add targeted class to new line operator
			$targeted.addClass('target-operator');
		});

		//bind click event to the preview operator
		$('#preview-operator').click(function() {
			//if isn't visible
			if($(this).attr('data-visible')=='false'){
				$(this).stop().animate({left:'0px'}, 1000, function(){
					//make visible
					$(this).attr('data-visible', 'true');
					//set src for iframe if not already set
					if($('#preview-operator iframe').attr('src')==""){
						$('#preview-operator iframe').attr('src', "/display/index?operator="+operator+"&view="+viewMode+"&work="+work);
					}
				});
			} else {
				//make it no visible
				$(this).animate({left:'-100%'}, 1000, function(){
					$(this).attr('data-visible', 'false');
				});
				//should maybe reset the src of the iframe to "" so that it's not continuing to pull the server while hidden -!!!-
			}

		});
		
		//bind click event to the blackout operator
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

		//bind click event to the up button
		$('#up-button-operator').click(function(){
			//if current is not data sequence 0
			if($current.attr('data-sequence') != 0) {
				//traverse previous line operators until a visible one is found
				$targeted.removeClass('target-operator');
				$targeted = $current.prev();
				while($targeted.attr('data-visibility') == "false") 
					$targeted = $targeted.prev();
				//commit
				commit();
			}
		});

		//bind click event to the down button
		$('#down-button-operator').click(function(){
			//if current is not the last data-sequence
			if($current.attr('data-sequence') != $('.line_operator').last().attr('data-sequence')) {
				//traverse next line operators until a visible one is found
				$targeted.removeClass('target-operator');
				$targeted = $current.next();
				while($targeted.attr('data-visibility') == "false") 
					$targeted = $targeted.next();
				//commit
				commit();
			}
		});

		//hide the shade loading operator once the page has loaded
		$('#shade-loading-operator').fadeOut(1000, function(){});
	}
});