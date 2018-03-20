$(document).ready(function(){
	//$('#comment_list_id').addClass('hide')
	//$('#render_new_comment').addClass('hide')
	alert(1);
    $('#show_comments').on('click', function(event) {
    	event.preventDefault();
    	$('#last_comment_id').toggle();
    	$('#comment_list_id').toggleClass('hide',!$('#comment_list_id').hasClass('hide'));
    	if(!$('#comment_list_id').hasClass('hide')){
    		$('a#show_comments').text('Show last Comment');
    	}else{
    		$('a#show_comments').text('Show all Comments');
    	}
    });
    $('#button_new').on('click', function(event) {
    	event.preventDefault();
    	$('#render_new_comment').toggleClass('hide',!$('#render_new_comment').hasClass('hide'));
    	$('#button_new').toggle()
    });
    $('.reply_button').on('click', function(event) {
    	event.preventDefault();
    	$('#image_' + $(this).attr('id')).toggleClass('hide',!$('#image_' + $(this).attr('id')).hasClass('hide'));
        if(!$('#image_' + $(this).attr('id')).hasClass('hide')){
    		$('#' + $(this).attr('id')).text('Hide');
    	}else{
    		$('#' + $(this).attr('id')).text('Reply');
    	}
    });
});