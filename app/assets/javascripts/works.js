$(document).ready(function(){
	if($('#body-editorview-works').length>0){
		console.log('hello there');
		var $contentBox = $('#text_content_text');
		$('#supBlank').click(function(){

			console.log('how\'m I doing so far?');
			$contentBox.val($contentBox.val() + '<br />');


		});
	}
})