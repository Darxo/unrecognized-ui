::modURUI.HooksMod.hook("scripts/entity/tactical/player", function(q) {
// Summarized Mood Icon
	// Hooks so that the summarized MoodIcon is updated whenever there was any change to player mood
	q.improveMood = @(__original) function( _amount = 1.0, _reason = "")
	{
		__original(_amount, _reason);
		::modURUI.updateTopbarAssets();
	}

	q.worsenMood = @(__original) function( _amount = 1.0, _reason = "")
	{
		__original(_amount, _reason);
		::modURUI.updateTopbarAssets();
	}

	// Every time a brother is added to the player-roster that also triggers onHired. So I want to update the Mood here too
	q.onHired = @(__original) function()
	{
		__original();
		::modURUI.updateTopbarAssets();
	}

// Custom Overlay Bars
	q.onCombatStart = @(__original) function()
	{
		__original();
		this.m.CustomOverlayBars.reset();
	}
});
