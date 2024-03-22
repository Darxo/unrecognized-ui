TacticalScreenTopbarOptionsModule.prototype.setToggleStatsOverlaysButtonState = function (_state)
{
	// Vanilla will still call this function with bools but we ignore those calls from now on
	if (_state !== null && typeof(_state) === 'string')
	{
		if		(_state === "Always Show")
			this.mToggleStatsOverlaysButton.changeButtonImage(Path.GFX + Asset.BUTTON_TOGGLE_STATS_OVERLAYS_ENABLED);
		else if (_state === "Only While Damaged")
			this.mToggleStatsOverlaysButton.changeButtonImage(Path.GFX + modURUI.BUTTON_TOGGLE_STATS_OVERLAYS_DAMAGED);
		else if (_state === "Never Show")
			this.mToggleStatsOverlaysButton.changeButtonImage(Path.GFX + Asset.BUTTON_TOGGLE_STATS_OVERLAYS_DISABLED);
	}
};


TacticalScreenTopbarOptionsModule.prototype.setHighlightBlockedTilesButtonState = function (_state)
{
	// Vanilla or Mods may still call this function with bools but we ignore those calls from now on
	if (_state !== null && typeof(_state) === 'string')
	{
		if 		(_state === "Hidden")
			this.mToggleHighlightBlockedTilesButton.changeButtonImage(Path.GFX + Asset.BUTTON_TOGGLE_HIGHLIGHT_BLOCKED_TILES_DISABLED);
		else if (_state === "Custom")
			this.mToggleHighlightBlockedTilesButton.changeButtonImage(Path.GFX + modURUI.BUTTON_TOGGLE_HIGHLIGHT_BLOCKED_TILES_CUSTOM);
		else if (_state === "Vanilla")
			this.mToggleHighlightBlockedTilesButton.changeButtonImage(Path.GFX + Asset.BUTTON_TOGGLE_HIGHLIGHT_BLOCKED_TILES_ENABLED);
	}
};


