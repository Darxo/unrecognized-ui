::modURUI.UIF <- {}

if ((::Const.Items.ItemFilter.Armor & ::Const.Items.ItemType.Shield) != 0)
{
	::Const.Items.ItemFilter.Armor -= ::Const.Items.ItemType.Shield;	// Armor Filter no longer displays shields
}

// Weapon Filter now displays shields
::Const.Items.ItemFilter.Weapons = ::Const.Items.ItemFilter.Weapons | ::Const.Items.ItemType.Shield;

// Set up tooltips new filter button
::modURUI.Mod.Tooltips.setTooltips({
	TownShopDialogModule = {
		ToggleSlotVisibility = ::MSU.Class.BasicTooltip("Toggle Slot Visibility", "Hide/Show all empty slots in your stash. Does not affect the shop inventory")
	},
	CharacterScreenInventoryListModule = {
		ToggleSlotVisibility = ::MSU.Class.BasicTooltip("Toggle Slot Visibility", "Hide/Show all empty slots in your stash.")
	}
});
