//javascript for operator view goes here
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};
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
		});
		//this happens when you click the commit button
		$('#commit-button-operator').click(function(){
			//post the sequence of the selected line via ajax
			console.log('line committed');
		});
		$('#line-holder-operator').scroll(function(){
			var updateInt = 300;
			//logic that happens when scrolling goes here
			//console.log($('#line-holder-operator div.line-operator'));
			//check position of any line (4)
			//$('#line-operator-' + 4).offset();
			/*
			console.log(
				//scrolltop holds the key
				$('#line-holder-operator').scrollTop()
				);
			*/
			//self destroying counter that catches up the highlighting
			if(!window.counting){
				window.counting = setTimeout(function(){

					$('#line-holder-operator div.line-operator').each(function(q){
						$(this).removeClass('target-operator');
					})
					var mid = $(window).innerHeight()/2.2;
					var l = _.sortBy($('#line-holder-operator div.line-operator'), function(q){
						return Math.abs($(q).offset().top-mid);
					})
					$(l[0]).addClass('target-operator');
					//console.log(l);
					console.log('catch up');
					//destroy the counter
					window.counting=false;
				}, updateInt);
			}
		
			//console.log($('#line-holder-operator div.line-operator').position().top);
		})
	}

});