::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(o)
{
// Useful Item Filter
	// Pass information about our squirrel item filter over to javascript
	local oldQueryShopInformation = o.queryShopInformation;
	o.queryShopInformation = function()
	{
		local ret = oldQueryShopInformation();
		ret.Filter1 <- ::Const.Items.ItemFilter.All;
		ret.Filter2 <- ::Const.Items.ItemFilter.Weapons;
		ret.Filter3 <- ::Const.Items.ItemFilter.Armor;
		ret.Filter4 <- ::Const.Items.ItemFilter.Usable;
		ret.Filter5 <- ::Const.Items.ItemFilter.Misc;
		return ret;
	}
});
