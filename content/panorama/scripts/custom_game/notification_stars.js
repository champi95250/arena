"use strict";

(function () {
	GameEvents.Subscribe( "stars_notification", notification_stars);

})();


function notification_stars(msg ,data){
	$.GetContextPanel().SetHasClass( "etoileenable", true );
	$( "#AlertMessage_etoile" ).html = true;
	var hero_image_name = "file://{images}/custom_game/button/etoile.png";
	$( "#PickupMessage_Etoile" ).SetImage( hero_image_name );
	$( "#AlertMessage_etoile" ).text = msg.nombredetoile;
}