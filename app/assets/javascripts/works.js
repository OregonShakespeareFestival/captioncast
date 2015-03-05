$(document).ready(function(){
	console.log('hello there');
	
//**********************************************
//sets the value and class of the char_count box
//*********************************************
$('#char_count').val($('#text_content_text').val().length);
if($('#char_count').val() > $('#char_allowed').val()){
	$('#char_count').addClass('above_limit');
}

//***********************************************
//inserts a non visible newline on the screen
//***********************************************
//	var $contentBox = $('#text_content_text');
//	$('#supBlank').click(function(){	
//		$contentBox.val($contentBox.val() + '<br />');
//		});


//***********************************************
// updates the count on change of characters currently
// in the editor textarea
//***********************************************
$('#text_content_text').keyup(function() {
    var cs = $(this).val().length;
    $('#char_count').val(cs);
    if(cs > $('#char_allowed').val()){
    	$('#char_count').addClass('above_limit');
    }
    else{
    	$('#char_count').removeClass('above_limit');
    }

});

//***********************************************
//changes the database visible value for element
//***********************************************
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

	//***********************************************
	//used for bolding selected lines in the editorview
	//***********************************************
	$('#boldIt').click(function(){

		   var textComponent = document.getElementById('text_content_text');
		   
		   var selectedText;
		//   // IE version
		   	if (document.selection != undefined){
		     	textComponent.focus();
		     	var sel = document.selection.createRange();
		     	selectedText = sel.text;
				}
			  // Mozilla version
			else if (textComponent.selectionStart != undefined){
		    	var startPos = textComponent.selectionStart;
		    	var endPos = textComponent.selectionEnd;
		    	selectedText = textComponent.value.substring(startPos, endPos)
		  		}
  		//bolds the text that is highlighted in the textarea		
		$('textarea#text_content_text').val(
			$('textarea#text_content_text').val().substring(0, textComponent.selectionStart) 
			+ selectedText.toUpperCase()
			+ $('textarea#text_content_text').val().substring(textComponent.selectionEnd));

		});


		//***********************************************
		//going to split a line base on the cursers location in the textarea
		//***********************************************
		//$('.visi').click(function(){
/*			$vis = $(this);
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
		});*/

	});	// onload

