$(document).ready(function(){

    //***********************************************
    // controls scrolling down to the last edited line
    //************************************************
    var mid = Math.round($(window).innerHeight()/2);
    var editEl = $(".focus-here");
    if(editEl.length > 0) {
        $("html, body").animate({ scrollTop: editEl.offset().top +  Math.round(editEl.height()/2) - mid}, 500);
        editEl.css("background-color", "#FF5B00");
    }


    //***********************************************
    //changes the database visible value for element
    //***********************************************
    $('.visi').on("click", function(){
        $vis = $(this);
        console.log(this);
        console.log('visi changed');
        //$(this).toggleClass('visiTr');
        $.ajax('/texts/toggleVis', {
            data:{
                id: $vis.attr('data-id')
            },
            method: 'POST',
            success: function(d){
                if($vis.hasClass("glyphicon-eye-open")) {
                    $vis.removeClass("glyphicon-eye-open");
                    $vis.addClass("glyphicon-eye-close");
                }
                else {
                    $vis.removeClass("glyphicon-eye-close");
                    $vis.addClass("glyphicon-eye-open");
                }
            },
        });
    });

});
