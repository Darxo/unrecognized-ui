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

// Adjust display of Fatigue/Initiative/Morale
	q.addStatsToUIData = @(__original) function( _entity, _target )
	{
		__original(_entity, _target);

		if (::modURUI.Mod.ModSettings.getSetting("UseLocalMaxMorale").getValue())
		{
			_target.moraleMax = _entity.m.MaxMoraleState;	// The entity now provides the maximum morale to compare against when constructing the ProgressBar
		}
		else
		{
			_target.moraleMax = ::Const.MoraleState.Confident;	// Vanilla Fix: In Vanilla the maximum is "Ignore". But Ignore is more a sibling to "Steady" than the highest achievable morale
		}

		local baseProperties = _entity.getBaseProperties();
		if (::modURUI.Mod.ModSettings.getSetting("DisplayBaseInitiative").getValue())
		{
			_target.initiativeMax = baseProperties.getInitiative();
		}

		if (::MSU.Utils.hasState("tactical_state")) return;
		// Now only non-battle stuff:

		// We only change the displayed Stamina outside of combat. During battle the current fatigue is much more important to display there
		if (::modURUI.Mod.ModSettings.getSetting("DisplayBaseFatigue").getValue())
		{
			_target.fatigue = _target.fatigueMax;
			_target.fatigueMax = baseProperties.Stamina;
		}
	}
});
