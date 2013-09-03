$(document).ready(function(){
    var bullet = $.bullet('ws://localhost:8080/bullet');
    bullet.onopen = function(){
	$('#status').text('online');
    };
    bullet.ondisconnect = function(){
	$('#status').text('offline');
    };
    bullet.onmessage = function(e){
	if (e.data != 'pong'){
	    $('#chat_area').append(e.data + '\n');
	}
    };
    bullet.onheartbeat = function(){
	console.log('ping');
	bullet.send('ping');
    };

    $('#send_button').click(function() {
	bullet.send($('#input_text').val());
    });
});
