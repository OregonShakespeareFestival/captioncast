//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
var targeted = 1;
var current = 1;
$(document).ready(function(){

	//if we're in the operator view
	if($('#main-operator').length>0){
		$('#main-operator').height($(window).innerHeight()+'px');

		//console.log('this is the operator view');
		//set the templates
		var tLine = _.template($('#line-template-operator').html());
		
		//make sure the lines are sorted by sequence instead of index when read in
		lines = _.sortBy(lines,function(q){
			return q.sequence;
		});

		//waiting to get data vended in for characters

		//probably won't need this but hanging onto it for now
		//split each line into content and character. Assume 0 to first colon in line is character name
		/*
		_.each(lines, function(q, i){
			lines[i].character = q.content_text.substring(0, q.content_text.indexOf(':'));
			lines[i].line = q.content_text.substring(0, q.content_text.indexOf(':'));

		});
		*/
		//templating per line
		_.each(lines, function(q, i){
			//this is a temporary scrub in of fixture characters
			q.character = 'Character';

			//append character name with colon
			if(q.character.length>0){
				//append the colon
				q.character = q.character + ':';
			}else{
				q.character=' ';
			}


			//console.log(q.content_text);
			//if the line is visible then show it?
			//maybe we want it just a different color for operator view
			//evens and odds?
			if(i%2==0){
				q.even=true;

			}else{
				q.even=false;
			}
			if(q.visibility){
				$('#line-holder-sub-operator').append(
					tLine(q)
				);
			}
			$('.line-operator').first().addClass('target-operator');
		});
		//this happens when you click the commit button
		$('#commit-button-operator').click(function(){
			//post the sequence of the selected line via ajax
			
			$.ajax('/operator/pushTextSeq', {
				type:'POST',
				data: {
					seq:$('.target-operator').attr('data-sequence')
				},
				success:(function(d){
					//console.log('line pushed ' + d);
				}),
			});
			
			$('.current-operator').removeClass('current-operator');

			$('.target-operator').addClass('current-operator');
		});
		//scrolling target feature
		$('#line-holder-operator').scroll(function(){
			var updateInt = 100;
			//self destroying counter that catches up the highlighting
			if(!window.counting){
				window.counting = setTimeout(function(){
					//removed the targeted class
					$('.target-operator').removeClass('target-operator');
					var mid = $(window).innerHeight()/2.2;
					var l = _.sortBy($('#line-holder-operator div.line-operator'), function(q){
						return Math.abs($(q).offset().top-mid);
					})
					$(l[0]).addClass('target-operator');
					targeted = parseInt($(l[0]).attr('data-sequence'));
					//destroy the counter
					window.counting=false;
				}, updateInt);
			}
		
		});
		//click the line I want feature
		$('.line-operator').click(function(){
			var scrollSpd = 500;
			var diff = ($('.target-operator').position().top - $(this).position().top)*.9;
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
						$('#preview-operator iframe').attr('src', "/display/index");
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
				console.log($(this).val());
				var s = $(this).val();
				var l = _.find($('.line-operator'), function(q){
					return $(q).attr('data-sequence')==s;
				});
				console.log(l);
				//this may be able to be abstracted to a single function
				
				var scrollSpd = 500;
				if(l){
				var diff = ($('.target-operator').position().top - $(l).position().top)*.9;
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
			console.log('blackout');
			$.ajax('/operator/pushTextSeq', {
				type:'POST',
				data: {
					seq:0
				},
				success:(function(d){
					console.log('display cleared');
					$('.current-operator').removeClass('current-operator');
				}),
			});


		});

	}

});