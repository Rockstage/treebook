window.setTimeout(function() {
        $(".alert").fadeTo(500, 0).slideUp(500, function(){
            $(this).alert('close'); 
        });
    }, 5000);

