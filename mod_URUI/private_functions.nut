::modURUI.updateTopbarAssets <- function()
{
	if (::MSU.Utils.hasState("tactical_state")) return;
	if (::World.State.getPlayer() == null) return;  // We can't make an UI update if the player object doesnt exist yet
	::World.State.updateTopbarAssets();
}

::modURUI.generateModlist <- function()
{
	local allMods = ::Hooks.getMods();
	local modNameString = "";
	foreach (mod in allMods)
	{
		if (mod.getID() == "vanilla") continue;			// Skip vanilla entry
		if (mod.getID().find("dlc_") != null) continue;	// Skip all vanilla DLCs
		// if (mod.getID() == "mod_hooks") continue;			// Skip modding hooks as it should be part of any modded playthrough anyways
		// if (mod.getID() == "mod_modern_hooks") continue;
		// if (mod.getID() == "mod_msu") continue;			// Skip MSU because it is also essential
		// ::logWarning(mod.Name + " " + mod.Version + " " + mod.FriendlyName);
		modNameString += (mod.getName() + "; ");
	}
	::modURUI.Mod.ModSettings.getSetting("ModListOutput").set(modNameString, true, true, true, true);
}
