// New self-contained Namespace 'HBT' (Highlight Blocked Tiles)

::modURUI.HBT <- {
	// State
	TileOverlay = null,

	// Const
	Spritename = "blocked_tiles_overlay",
	HighlightDefault = "zone_target_overlay",
	HighlightEye = "zone_target_overlay_eye",

	// Enum describing the internal current state of the Highlighting
	BlockedState = {
		Hidden = "Hidden",
		Custom = "Custom",
		Vanilla = "Vanilla"
	}

	// Enum for the MSU Settings
	HighlightOption = {
		Both = "Both"
		Custom = "Custom Only"
		Vanilla = "Vanilla Only"
	}

	// Global
	HighlightedEntities = [],	// Array of Entities which have a highlight sprite attached
	WorldFlag = "URUI_HighlightState"
}

// Toggles the current state to the next in line
::modURUI.HBT.toggleHighlightState <- function()
{
	local availableOptions = ::modURUI.Mod.ModSettings.getSetting("BlockedTilesOptions").getValue();

	local blockedTilesModeSetting = ::modURUI.HBT.TileOverlay;

	if (blockedTilesModeSetting == ::modURUI.HBT.BlockedState.Hidden)
	{
		if (availableOptions == ::modURUI.HBT.HighlightOption.Vanilla) ::modURUI.HBT.setHighlightState(::modURUI.HBT.BlockedState.Vanilla);
		else ::modURUI.HBT.setHighlightState(::modURUI.HBT.BlockedState.Custom);
	}
	else if (blockedTilesModeSetting == ::modURUI.HBT.BlockedState.Custom)
	{
		if (availableOptions == ::modURUI.HBT.HighlightOption.Custom) ::modURUI.HBT.setHighlightState(::modURUI.HBT.BlockedState.Hidden);
		else ::modURUI.HBT.setHighlightState(::modURUI.HBT.BlockedState.Vanilla);
	}
	else if (blockedTilesModeSetting == ::modURUI.HBT.BlockedState.Vanilla)
	{
		::modURUI.HBT.setHighlightState(::modURUI.HBT.BlockedState.Hidden);
	}
}

::modURUI.HBT.setHighlightState <- function( _newState = null )
{
	if ("Flags" in ::World && ::World.Flags != null)	// During Scenarios this is false
	{
		::World.Flags.set(::modURUI.HBT.WorldFlag, _newState);
	}
	::modURUI.HBT.TileOverlay = _newState;

	::modURUI.HBT.applyCustomHighlight(_newState == ::modURUI.HBT.BlockedState.Custom);

	local settings = ::Settings.getTempGameplaySettings();
	settings.HighlightBlockedTiles = (_newState == ::modURUI.HBT.BlockedState.Vanilla);
	::Tactical.setBlockedTileHighlightsVisibility(settings.HighlightBlockedTiles);

	::Tactical.State.m.TacticalScreen.getTopbarOptionsModule().setToggleHighlightBlockedTilesListenerButtonState(_newState);
}

::modURUI.HBT.applyCustomHighlight <- function( _visible )
{
	foreach (entity in ::modURUI.HBT.HighlightedEntities)
	{
		if (entity == null) continue;
		if (entity.isAlive == null) ::MSU.Log.printData(entity, 2);
		if (!entity.isAlive()) continue;
		entity.getSprite("blocked_tiles_overlay").Visible = _visible;
	}
}

::modURUI.HBT.generateSingleOverlay <- function(_entity)
{
	if (_entity == null) 							return;
	if (!_entity.isAlive()) 						return;
	if (_entity in ::modURUI.HBT.HighlightedEntities) 	return;
	if (_entity.isAttackable()) 					return;		// Hopefully this is enough to filter out everything that can move

	local overlaySprite = _entity.addSprite(::modURUI.HBT.Spritename);
	if (_entity.isBlockingSight())
	{
		overlaySprite.setBrush(::modURUI.HBT.HighlightEye);
	}
	else
	{
		overlaySprite.setBrush(::modURUI.HBT.HighlightDefault);
	}
	overlaySprite.setOffset(::createVec(0, 6));
	overlaySprite.Visible = (::modURUI.HBT.TileOverlay == ::modURUI.HBT.BlockedState.Custom);

	local weakEntity = _entity.weakref();
	::modURUI.HBT.HighlightedEntities.push(weakEntity);
}
