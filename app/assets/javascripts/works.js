$(document).ready(function(){
	console.log('hello there');
	var $contentBox = $('#text_content_text');
	$('#supBlank').click(function(){

		console.log('how\'m I doing so far?');
		$contentBox.val($contentBox.val() + '<br />');


	});

//changes the database visible value for element
	$('.visi').click(function(){
		$vis = $(this);
		console.log(this);
		console.log('visi changed');
		//$(this).toggleClass('visiTr');
		$.ajax('/texts/toggleVis',
			{
				data:{
					id: $vis.attr('data-id')
					},
				method: 'POST',
				success:(function(d){
					//console.log('success');
					//console.log(d);
					$vis.toggleClass('visiTr');

				}),
				error:(function(e){
					//console.log(e);
					//console.log('error');
					//console.log('i got nothing');
				})
			}
		);

	});


	//used for bolding entire lines
	$('#boldIt').click(function(){
		var text = $('textarea#text_content_text').val();

		console.log(text);
		text = text.toUpperCase();
		$('textarea#text_content_text').val(text);

				//TODO: highlight only selected text
				// function ShowSelection()
				// {
				//   var textComponent = document.getElementById('Editor');
				//   var selectedText;
				//   // IE version
				//   if (document.selection != undefined)
				//   {
				//     textComponent.focus();
				//     var sel = document.selection.createRange();
				//     selectedText = sel.text;
				//   }
				//   // Mozilla version
				//   else if (textComponent.selectionStart != undefined)
				//   {
				//     var startPos = textComponent.selectionStart;
				//     var endPos = textComponent.selectionEnd;
				//     selectedText = textComponent.value.substring(startPos, endPos)
				//   }
				//   alert("You selected: " + selectedText);
				// }

	});

})