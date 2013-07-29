$('.cancel-review').click(function (event) {
	event.preventDefault();
	$('.button-review').show();
	$(".ratings").show();
	$('#new_review').html('');
});

$('.button-submit').click(function (event) {
	event.preventDefault();
    var dat = JSON.stringify($("#new_review").serialize());
    console.log(dat);
	$.ajax({
		type: 'POST',
		url: $("#new_review").attr('action'),
		data: dat,
		beforeSend: function(r){ $('#messageDiv').addClass('alert alert-info');$('#messageDiv').html('<p style="padding: 20px">Loading <img src="/assets/ratyloader.gif"/></p>');},
		success: function(r){ 
			$('#messageDiv').removeClass('alert alert-info');
			$('#messageDiv').html("");
		},
		error: function(r){
			$('#messageDiv').addClass('alert alert-error');
			$('#messageDiv').html("error")
		}
	});
});