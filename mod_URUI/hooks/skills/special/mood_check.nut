::modURUI.HooksMod.hook("scripts/skills/special/mood_check", function(q) {
// Show Mood Icon
	// This hook should catch all instances of Brothers leaving the company other than you dismissing them
	// This is because the onDeath function for skills is called even if the brother is removed by an event (like desertion)
	q.onDeath = @(__original) function( _fatalityType )
	{
		__original(_fatalityType);
		if (::MSU.Utils.hasState("tactical_state")) return;
		::World.State.updateTopbarAssets();
	}
});
