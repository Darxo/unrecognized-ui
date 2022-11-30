::mods_hookExactClass("skills/special/mood_check", function(o)
{
// Show Mood Icon
    // This hook should catch all instances of Brothers leaving the company other than you dismissing them
    // This is because the onDeath function for skills is called even if the brother is removed by an event (like desertion)

    local oldOnDeath = ::mods_getMember(o, "onDeath");      // Because only the parent of this class has an onDeath function defined in vanilla
    o.onDeath <- function( _fatalityType )
    {
        oldOnDeath(_fatalityType);
		if (::MSU.Utils.hasState("tactical_state")) return;
        ::World.State.updateTopbarAssets();
    }
});
