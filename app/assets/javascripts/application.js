// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree
//= require_self
//= require jquery
//= require bootstrap-sprockets
 
$(document).ready(function(){
	//$('#comment_list_id').addClass('hide')
	//$('#render_new_comment').addClass('hide')
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

