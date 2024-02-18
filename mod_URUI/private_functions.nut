::modURUI.updateTopbarAssets <- function()
{
	if (::MSU.Utils.hasState("tactical_state")) return;
	if (::World.State.getPlayer() == null) return;  // We can't make an UI update if the player object doesnt exist yet
	::World.State.updateTopbarAssets();
}
