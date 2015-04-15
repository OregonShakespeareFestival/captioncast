$(document).ready(function() {
	if($("#body-preview-index").length > 0) {
		var refreshRate = 300;

		//make update happen
		function updatePreview(current) {
			//insert line
			$("#line-preview-current .line-content-preview").html(current);
			//update position relative to size
			var height = $("#line-preview-current").height();
			var winHeight = $(window).height();
			$("#line-preview-current").css("top", winHeight/2-height/2);
		}

		//check for update
		function heartbeat() {
			$.ajax({
				url:"/preview/getLineSequence",
				type:"post",
				data: {
					operator: operator
				},
				success:function(data) {
					if(data.content != $("#line-preview-current").html().trim())
						updatePreview(data.content);
				},
				error:function() {
					alert("Display failed to update. Please refresh and try again.");
				}
			});
		}

		window.setInterval(heartbeat, refreshRate);
	}
});