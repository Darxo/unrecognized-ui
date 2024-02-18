// New self-contained Namespace 'COB' (Custom Overlay Bars)

::modURUI.COB <- {
	// Const
	AlwaysShow = {
		Icon = "icon_tabs",
		Setting = "Always Show",
		ButtonTitle = "Always show overlay",
		ButtonDescription = "Overlay bars as well as status effect icons are always visible ontop of characters"
	}
	OnlyWhileDamaged = {
		Icon = "icon_tabs_damaged",
		Setting = "Only While Damaged",
		ButtonTitle = "Only show overlay while damaged",
		ButtonDescription = "Overlay bars as well as status effect icons are always only visible ontop of damaged characters"
	}
	NeverShow = {
		Icon = "icon_tabs_deactivated",
		Setting = "Never Show",
		ButtonTitle = "Never show overlay",
		ButtonDescription = "Overlay bars as well as status effect icons are never visible ontop of characters"
	}
}

// Toggles the overlay mode between its 3 states. In vanilla it only has 2 states
::modURUI.COB.toggleOverlayMode <- function()
{
	local displayModeSetting = ::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode");
	if (displayModeSetting.getValue() == ::modURUI.COB.AlwaysShow.Setting)
	{
		displayModeSetting.set(::modURUI.COB.OnlyWhileDamaged.Setting, true, true, true, true);
	}
	else if (displayModeSetting.getValue() == ::modURUI.COB.OnlyWhileDamaged.Setting)
	{
		displayModeSetting.set(::modURUI.COB.NeverShow.Setting, true, true, true, true);
	}
	else if (displayModeSetting.getValue() == ::modURUI.COB.NeverShow.Setting)
	{
		displayModeSetting.set(::modURUI.COB.AlwaysShow.Setting, true, true, true, true);
	}
}
