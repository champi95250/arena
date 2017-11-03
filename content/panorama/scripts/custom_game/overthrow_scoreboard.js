function OnUpdatenoww( msg , data )
{
	$.GetContextPanel().SetHasClass( "VictoryPanel", true );
	// var Scoreafaire = teamPanel.GetAttributeInt( "recent_score_count", 0 );

	$( "#VictoryPoints" ).text = msg.Teampointtowin;
}


(function()
{
	// We use a nettable to communicate victory conditions to make sure we get the value regardless of timing.
	GameEvents.Subscribe( "victory_condition", OnUpdatenoww );

})();

