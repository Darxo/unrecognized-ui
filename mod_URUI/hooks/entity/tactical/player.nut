::mods_hookExactClass("entity/tactical/player", function(o) {
// Summarized Mood Icon
    // Hooks so that the summarized MoodIcon is updated whenever there was any change to player mood
    local oldImproveMood = o.improveMood;
    o.improveMood = function( _amount = 1.0, _reason = "")
    {
        oldImproveMood(_amount, _reason);
        ::modURUI.updateTopbarAssets();
    }

    local oldWorsenMood = o.worsenMood;
    o.worsenMood = function( _amount = 1.0, _reason = "")
    {
        oldWorsenMood(_amount, _reason);
		::modURUI.updateTopbarAssets();
    }

    // Every time a brother is added to the player-roster that also triggers onHired. So I want to update the Mood here too
    local oldOnHired = o.onHired;
    o.onHired = function()
    {
        oldOnHired();
        ::modURUI.updateTopbarAssets();
    }

// Custom Overlay Bars
    local oldOnCombatStarted = o.onCombatStart;
    o.onCombatStart = function()
    {
        oldOnCombatStarted();
        this.m.CustomOverlayBars.reset();
    }

});
