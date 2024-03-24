::modURUI.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
// Useful Item Filter
	q.queryData = @(__original) function()
	{
		local ret = __original();

		::modURUI.RWI.calculateWarnings();
		ret.FormationWarning <- ::modURUI.RWI.FormationWarning;
		local rosterSize = (("State" in ::World) && ::World.State != null ? ::World.Assets.getBrothersMaxInCombat() : 12);
		ret.FormationMaxSize <- rosterSize;

		// Pass information about our squirrel item filter over to javascript
		if (this.m.InventoryMode != ::Const.CharacterScreen.InventoryMode.Ground)
		{
			ret.Filter1 <- ::Const.Items.ItemFilter.All;
			ret.Filter2 <- ::Const.Items.ItemFilter.Weapons;
			ret.Filter3 <- ::Const.Items.ItemFilter.Armor;
			ret.Filter4 <- ::Const.Items.ItemFilter.Usable;
			ret.Filter5 <- ::Const.Items.ItemFilter.Misc;
		}

		return ret;
	}

// Summarized Mood Icon
	// Hooks so that the summarized MoodIcon is updated whenever there was any brother is dismissed
	q.onDismissCharacter = @(__original) function( _data )
	{
		__original(_data);
		::World.State.updateTopbarAssets();
	}

// New Functions
	// Roster Warning Icon
	q.setWarning <- function(_warningActive)
	{
		if (this.m.JSDataSourceHandle != null)
		{
			local rosterSize = ("State" in ::World) && ::World.State != null ? ::World.Assets.getBrothersMaxInCombat() : 12;
			this.m.JSDataSourceHandle.asyncCall("setWarning", [_warningActive, rosterSize]);
		}
	}
});
