::modURUI.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
// Summarized Mood Icon - Roster Warning Icon
	// This is called whenever anything calls ::World.State.updateTopbarAssets()
	q.convertEntityToUIData = @(__original) function( _entity, isLastEntity = false )
	{
		local ret = __original(_entity, isLastEntity);

		if (::modURUI.Mod.ModSettings.getSetting("UseLocalMaxMorale").getValue())
		{
			ret.moraleMax = _entity.m.MaxMoraleState;	// The entity now provides the maximum morale to compare against when constructing the ProgressBar
		}
		else
		{
			ret.moraleMax = ::Const.MoraleState.Confident;	// Vanilla Fix: In Vanilla the maximum is "Ignore". But Ignore is more a sibling to "Steady" than the highest achievable morale
		}

		return ret;
	}
});
