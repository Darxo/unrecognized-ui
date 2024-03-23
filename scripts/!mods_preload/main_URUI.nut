::modURUI <- {
	ID = "mod_URUI",
	Name = "Unrecognized UI",
	Version = "1.2.0",
	GitHubURL = "https://github.com/Darxo/unrecognized-ui",
	Const = {},
	Class = {}
}

::modURUI.HooksMod <- ::Hooks.register(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);
::modURUI.HooksMod.require(["mod_msu"]);

::modURUI.HooksMod.queue(">mod_msu", function()
{
	::modURUI.Mod <- ::MSU.Class.Mod(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);

	::modURUI.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::modURUI.GitHubURL);
	::modURUI.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_URUI/load")			// run all squirrel hooks and other code additions
	::include("mod_URUI/ui/load");		// Load all javascript and css files
});
