function OnRoundStarted( roundStartData )
{
	if ( roundStartData !== null )
	{
		$( "#RoundStartPanel" ).SetHasClass( "Round" + ( roundStartData.round_number - 1 ), false );  
		$( "#RoundStartPanel" ).SetHasClass( "Round" + roundStartData.round_number, true );
	}

	$( "#RoundStartPanel" ).SetHasClass( "Visible", true );
	$.Schedule( 8.0, HideRoundStart );
	$.DispatchEvent( "DOTAHUDHideScoreboard" )
}

function HideRoundStart()
{
	$( "#RoundStartPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "round_started", OnRoundStarted );



function PingMinimapAtLocation( msg )
{
  GameUI.PingMinimapAtLocation( msg.pos );        

}

(function () {
    GameEvents.Subscribe( "ping_minimap", PingMinimapAtLocation );
})();