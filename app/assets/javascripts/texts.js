$(document).ready(function(){
	console.log('here are texts to edit');

	if($('#body-index-texts').length>0){
			console.log('here are texts to edit x2');

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


	//used for splitting lines
		$('#splitIt').click(function(){
			$edt = $(this);
			console.log(this);
			console.log('split it changed');
			console.log($edt.attr('data-id')) //data-id = the id of the textline in the database (not sequence)
			//$(this).toggleClass('visiTr');
			// $.ajax('/texts/toggleVis',
			// 	{
			// 		data:{
			// 			id: $vis.attr('data-id')
			// 			},
			// 		method: 'POST',
			// 		success:(function(d){
			// 			//console.log('success');
			// 			//console.log(d);
			// 			$vis.toggleClass('visiTr');

			// 		}),
			// 		error:(function(e){
			// 			//console.log(e);
			// 			//console.log('error');
			// 			//console.log('i got nothing');
			// 		})
			// 	}
			// );

		});

	}


	

});