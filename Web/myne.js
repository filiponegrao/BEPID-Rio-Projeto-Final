$(document).ready(function(){

    $('#dialog-message').dialog({
        modal: true,
        autoOpen: false,
        buttons: {
            Ok: function() {
                $(this).dialog("close");
            }
        }
    });



    $('#button').on('click', function() {
        var email = $('#email').val();
        var dataString = '&email=' + email;
        $.ajax({
            type: "POST",
            url: "Testflight_add.php",
            data: dataString,
            success: function() {
                alert();
                $('#dialog-message').dialog('open');
            }
        });
    });

});
