::mods_hookNewObject("ui/global/data_helper", function (o) {

// Summarized Mood Icon - Roster Warning Icon
	// This is called whenever anything calls ::World.State.updateTopbarAssets()
	local oldConvertAssetsInformationToUIData = o.convertAssetsInformationToUIData;
	o.convertAssetsInformationToUIData = function()
	{
        // ::logWarning("convertAssetsInformationToUIData hook");
		local ret = oldConvertAssetsInformationToUIData();

		::modURUI.SMI.calculateRosterMood();
		::modURUI.RWI.calculateWarnings();

		ret.FormationWarning <- (::modURUI.RWI.FormationWarning && ::modURUI.Mod.ModSettings.getSetting("ShowRosterWarning").getValue())
        ret.RosterWarning <- (::modURUI.RWI.RosterWarning && ::modURUI.Mod.ModSettings.getSetting("ShowRosterWarning").getValue());
        ret.RosterMood <- ::modURUI.SMI.RosterMood
		return ret;
	}

// Useful Item Filter
	// Item-Data now also contain the type so javascript can filter those locally
	local oldConvertItemToUIData = o.convertItemToUIData;
    o.convertItemToUIData = function( _item, _forceSmallIcon, _owner = null )
	{
        local ret = oldConvertItemToUIData( _item, _forceSmallIcon, _owner );
        if (ret != null) ret.type <- _item.getItemType();
        return ret;
    }
});
