::modURUI.HooksMod.hook("scripts/states/tactical_state", function(q) {
	q.initStatsOverlays = @(__original) function()
	{
		__original();

		::Settings.getTempGameplaySettings().ShowOverlayStats = false;		// Hopefully it improves performance if this vanilla setting is perma inactive

		// Apply the current Custom Overlay Bars
		this.m.TacticalScreen.getTopbarOptionsModule().setToggleStatsOverlaysButtonState(::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue());

		// Initialization of TileOverlay variable. This is only done once each campaign
		if (::modURUI.HBT.TileOverlay == null)
		{
			if (("Flags" in ::World) && (::World.Flags != null) && ::World.Flags.has(::modURUI.HBT.WorldFlag))
			{
				::modURUI.HBT.TileOverlay = ::World.Flags.get(::modURUI.HBT.WorldFlag);
			}
			else
			{
				::modURUI.HBT.TileOverlay = ::modURUI.HBT.BlockedState.Hidden;
			}
		}

		::modURUI.HBT.setHighlightState(::modURUI.HBT.TileOverlay);
	}

// Custom Overlay Bars
	q.topbar_options_onToggleStatsOverlaysButtonClicked = @() function()	// Overwrite because we re-implement the vanilla behavior
	{
		::modURUI.COB.toggleOverlayMode();
	}

// Highlight Blocked Tiles
	q.topbar_options_onToggleHighlightBlockedTilesButtonClicked = @() function()
	{
		// if (this.isInputLocked()) return;	// Vanilla has this line but removing it allows changing this setting during enemies turn
		::modURUI.HBT.toggleHighlightState();
	}

	// Implement settings for improving the display of allied and enemy numbers during battle
	q.topbar_round_information_onQueryRoundInformation = @(__original) function()
	{
		local ret = __original();

		if (::modURUI.Mod.ModSettings.getSetting("RoundInformationAllyNumber").getValue() == "Brothers + Allies")
		{
			local brotherNum = ::Tactical.Entities.getInstancesNum(::Const.Faction.Player);
			local nonBrotherAllies = ret.brothersCount - brotherNum;
			if (nonBrotherAllies)
			{
				ret.brothersCount = brotherNum + " + " + nonBrotherAllies;
			}
		}

		if (::modURUI.Mod.ModSettings.getSetting("RoundInformationEnemyNumber").getValue() == "Visible (Total)")
		{
			local visibleEnemies = ::Tactical.Entities.getVisibleHostilesNum();
			ret.enemiesCount = visibleEnemies + " (" + ret.enemiesCount + ")";
		}

		return ret;
	}
});
