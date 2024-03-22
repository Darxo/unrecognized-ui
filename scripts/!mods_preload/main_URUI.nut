::modURUI <- {
	ID = "mod_URUI",
	Name = "Unrecognized UI",
	Version = "1.1.0",
	Const = {},
	Class = {}
}

::modURUI.HooksMod <- ::Hooks.register(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);
::modURUI.HooksMod.require(["mod_msu"]);

::modURUI.HooksMod.queue(">mod_msu", function()
{
	::modURUI.Mod <- ::MSU.Class.Mod(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);

	::include("mod_URUI/load")			// run all squirrel hooks and other code additions
	::include("mod_URUI/ui/load");		// Load all javascript and css files
});
