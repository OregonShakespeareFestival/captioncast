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


			console.log($('.target-operator').attr('data-sequence'));
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

	}

});