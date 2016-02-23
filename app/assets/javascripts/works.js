$(document).ready(function(){

//***********************************************
// controls scrolling down to the last edited line
//************************************************
var mid = Math.round($(window).innerHeight()/2);
var editEl = $(".focus-here");
$("html, body").animate({ scrollTop: editEl.offset().top +  Math.round(editEl.height()/2) - mid}, 500);
editEl.css("background-color", "#FF5B00");

//***********************************************
// updates the count on change of characters currently
// in the add a line textarea
//***********************************************
$('#new_line_content_text').keyup(function() {
    var cs = $(this).val().length;
    $('#added_char_count').val(cs);
    if(cs > parseInt($('#char_allowed').val())){
    	$('#added_char_count').addClass('above_limit');
    }
    else{
    	$('#added_char_count').removeClass('above_limit');
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
					if($vis.hasClass("glyphicon-eye-open")) {
						$vis.removeClass("glyphicon-eye-open");
						$vis.addClass("glyphicon-eye-close");
					}
					else {
						$vis.removeClass("glyphicon-eye-close");
						$vis.addClass("glyphicon-eye-open");
					}

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
			console.log("bold clicked");
		   var textComponent = document.getElementById('text_content_text');
		   
		   var selectedText;
		//   // IE version
		   	if (document.selection != undefined){
                console.log('not ie')
		     	textComponent.focus();
		     	var sel = document.selection.createRange();
		     	selectedText = sel.text;
				}
			  // Mozilla version
			else if (textComponent.selectionStart != undefined){
                console.log('not ie')
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

	});	// onload