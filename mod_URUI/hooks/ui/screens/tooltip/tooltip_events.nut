::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function(o)
{
    local oldGeneral_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
    o.general_queryUIElementTooltipData = function ( _entityId, _elementId, _elementOwner )
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

        local ret = oldGeneral_queryUIElementTooltipData( _entityId, _elementId, _elementOwner );
        if(_elementId == "tactical-screen.topbar.options-bar-module.ToggleStatsOverlaysButton")
        {
            local overlayMode = ::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue();
            foreach(textEntry in ret)
            {
                if (textEntry.id == 1 && textEntry.type == "title")
                {
                    if (overlayMode == ::modURUI.Const.AlwaysShow.Setting) textEntry.text = ::modURUI.Const.AlwaysShow.ButtonTitle;
                    if (overlayMode == ::modURUI.Const.OnlyWhileDamaged.Setting) textEntry.text = ::modURUI.Const.OnlyWhileDamaged.ButtonTitle;
                    if (overlayMode == ::modURUI.Const.NeverShow.Setting) textEntry.text = ::modURUI.Const.NeverShow.ButtonTitle;
                }
                if (textEntry.id == 2 && textEntry.type == "description")
                {
                    if (overlayMode == ::modURUI.Const.AlwaysShow.Setting) textEntry.text = ::modURUI.Const.AlwaysShow.ButtonDescription;
                    if (overlayMode == ::modURUI.Const.OnlyWhileDamaged.Setting) textEntry.text = ::modURUI.Const.OnlyWhileDamaged.ButtonDescription;
                    if (overlayMode == ::modURUI.Const.NeverShow.Setting) textEntry.text = ::modURUI.Const.NeverShow.ButtonDescription;
                }
            }
        }

        return ret;
    }
});
