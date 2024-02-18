::modURUI.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		// Correct vanilla tooltips for Weapon/Armor filter because we moved shields from one to the other filter
		if (_elementId == "character-screen.right-panel-header-module.FilterWeaponsButton")
		{
			return [
				{
					id = 1,
					type = "title",
					text = "Filter items by type"
				},
				{
					id = 2,
					type = "description",
					text = "Show only weapons, shields, offensive tools and accessories."
				}
			];
		}
		if (_elementId == "character-screen.right-panel-header-module.FilterArmorButton")
		{
			return [
				{
					id = 1,
					type = "title",
					text = "Filter items by type"
				},
				{
					id = 2,
					type = "description",
					text = "Show only armor and helmets."
				}
			];
		}

		local ret = __original( _entityId, _elementId, _elementOwner );

		if(_elementId == "tactical-screen.topbar.options-bar-module.ToggleStatsOverlaysButton")
		{
			local overlayMode = ::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue();
			foreach(textEntry in ret)
			{
				if (textEntry.id == 1 && textEntry.type == "title")
				{
					if (overlayMode == ::modURUI.COB.AlwaysShow.Setting) textEntry.text = ::modURUI.COB.AlwaysShow.ButtonTitle;
					if (overlayMode == ::modURUI.COB.OnlyWhileDamaged.Setting) textEntry.text = ::modURUI.COB.OnlyWhileDamaged.ButtonTitle;
					if (overlayMode == ::modURUI.COB.NeverShow.Setting) textEntry.text = ::modURUI.COB.NeverShow.ButtonTitle;
				}
				if (textEntry.id == 2 && textEntry.type == "description")
				{
					if (overlayMode == ::modURUI.COB.AlwaysShow.Setting) textEntry.text = ::modURUI.COB.AlwaysShow.ButtonDescription;
					if (overlayMode == ::modURUI.COB.OnlyWhileDamaged.Setting) textEntry.text = ::modURUI.COB.OnlyWhileDamaged.ButtonDescription;
					if (overlayMode == ::modURUI.COB.NeverShow.Setting) textEntry.text = ::modURUI.COB.NeverShow.ButtonDescription;
				}
			}
		}

		return ret;
	}
});
