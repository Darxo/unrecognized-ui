::mods_hookExactClass("states/tactical_state", function(o)
{
    local oldInitStatsOverlays = o.initStatsOverlays;
    o.initStatsOverlays = function()
	{
        oldInitStatsOverlays();

		::Settings.getTempGameplaySettings().ShowOverlayStats = false;		// Hopefully it improves performance if this vanilla setting is perma inactive

		// Apply the current Custom Overlay Bars
		local ob = this.m.TacticalScreen.getTopbarOptionsModule();
		ob.setToggleStatsOverlaysButtonState(::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue());

		// Apply the current Highlight Blocked Tiles Mode
        if (::World.Flags.has(::modURUI.HBT.WorldFlag) == false) ::World.Flags.set(::modURUI.HBT.WorldFlag, ::modURUI.HBT.BlockedState.Hidden);
        ::modURUI.HBT.setHighlightState(::World.Flags.get(::modURUI.HBT.WorldFlag));
	}

// Custom Overlay Bars
    o.topbar_options_onToggleStatsOverlaysButtonClicked = function()
    {
        ::modURUI.COB.toggleOverlayMode();
    }

// Highlight Blocked Tiles
	o.topbar_options_onToggleHighlightBlockedTilesButtonClicked = function()
	{
		// if (this.isInputLocked()) return;	// Vanilla has this line but removing it allows changing this setting during enemies turn
		::modURUI.HBT.toggleHighlightState();
	}
});
