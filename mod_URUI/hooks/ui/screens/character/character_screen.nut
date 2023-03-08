::mods_hookNewObject("ui/screens/character/character_screen", function(o)
{
// Useful Item Filter
    local oldQueryData = o.queryData;
    o.queryData = function()
    {
        local ret = oldQueryData();

        ::modURUI.RWI.calculateWarnings();
        ret.FormationWarning <- (::modURUI.RWI.FormationWarning && ::modURUI.Mod.ModSettings.getSetting("ShowRosterWarning").getValue());
        local rosterSize = (("State" in ::World) && ::World.State != null ? ::World.Assets.getBrothersMaxInCombat() : 12);
        ret.FormationMaxSize <- rosterSize;

        // Pass information about our squirrel item filter over to javascript
		if (this.m.InventoryMode != this.Const.CharacterScreen.InventoryMode.Ground)
		{
            ret.Filter1 <- ::Const.Items.ItemFilter.All;
            ret.Filter2 <- ::Const.Items.ItemFilter.Weapons;
            ret.Filter3 <- ::Const.Items.ItemFilter.Armor;
            ret.Filter4 <- ::Const.Items.ItemFilter.Usable;
            ret.Filter5 <- ::Const.Items.ItemFilter.Misc;
		}

        return ret;
    }

// Roster Warning Icon
	o.setWarning <- function(_warningActive)
	{
		if (this.m.JSDataSourceHandle != null)
		{
            local rosterSize = ("State" in ::World) && ::World.State != null ? ::World.Assets.getBrothersMaxInCombat() : 12;
			this.m.JSDataSourceHandle.asyncCall("setWarning", [_warningActive, rosterSize]);
		}
	}

// Summarized Mood Icon
    // Hooks so that the summarized MoodIcon is updated whenever there was any brother is dismissed
    local oldOnDismissCharacter = o.onDismissCharacter;
    o.onDismissCharacter = function( _data )
    {
        oldOnDismissCharacter(_data);
		::World.State.updateTopbarAssets();
    }
});
