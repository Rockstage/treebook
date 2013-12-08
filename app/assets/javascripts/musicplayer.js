$(document).ready(function(){
    var description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id tortor nisi. Aenean sodales diam ac lacus elementum scelerisque. Suspendisse a dui vitae lacus faucibus venenatis vel id nisl. Proin orci ante, ultricies nec interdum at, iaculis venenatis nulla. ';

    $('#player').ttwMusicPlayer(myPlaylist, {
        
        description:description,
        jPlayer:{
            swfPath:'jquery-jplayer' //You need to override the default swf path any time the directory structure changes
        }
    });
});
	    