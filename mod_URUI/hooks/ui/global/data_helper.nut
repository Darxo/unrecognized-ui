::modURUI.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
// Summarized Mood Icon - Roster Warning Icon
	// This is called whenever anything calls ::World.State.updateTopbarAssets()
	q.convertAssetsInformationToUIData = @(__original) function()
	{
		local ret = __original();

		::modURUI.SMI.calculateRosterMood();
		::modURUI.RWI.calculateWarnings();

		ret.FormationWarning <- ::modURUI.RWI.FormationWarning;
		ret.RosterWarning <- ::modURUI.RWI.RosterWarning;
		ret.RosterMood <- ::modURUI.SMI.RosterMood

		return ret;
	}

// Useful Item Filter
	// Item-Data now also contain the type so javascript can filter those locally
	q.convertItemToUIData = @(__original) function( _item, _forceSmallIcon, _owner = null )
	{
		local ret = __original(_item, _forceSmallIcon, _owner);

		if (ret != null) ret.type <- _item.getItemType();

		return ret;
	}

// Display max Fatigue/Initiative
	q.addStatsToUIData = @(__original) function( _entity, _target )
	{
		__original(_entity, _target);

		local baseProperties = _entity.getBaseProperties();

		if (::modURUI.Mod.ModSettings.getSetting("DisplayBaseInitiative").getValue()) _target.initiativeMax = baseProperties.getInitiative();

		// We only change the displayed fatigue outside of combat. During combat that stat is not important
		if (::MSU.Utils.hasState("tactical_state")) return;

		if (::modURUI.Mod.ModSettings.getSetting("DisplayBaseFatigue").getValue())
		{
			_target.fatigue = _target.fatigueMax;
			_target.fatigueMax = baseProperties.Stamina;
		}
	}
});
