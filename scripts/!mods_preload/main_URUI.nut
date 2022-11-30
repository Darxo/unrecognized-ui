::modURUI <- {
	ID = "mod_URUI",
	Name = "Unrecognized UI",
	Version = "1.0.0",
	Const = {},
	Class = {}
}

::mods_registerMod(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);

::mods_queue(::modURUI.ID, "mod_msu", function()
{
	::modURUI.Mod <- ::MSU.Class.Mod(::modURUI.ID, ::modURUI.Version, ::modURUI.Name);

	::includeFiles(::IO.enumerateFiles("mod_URUI/hooks"));		// run all squirrel hooks

	::include("mod_URUI/javascript_hooks");						// Load all javascript and css files

	::include("mod_URUI/private_functions");					// globally accessible but private functions
	::include("mod_URUI/public_functions");						// Functions meant to be called by other mods

	::include("mod_URUI/system/custom_overlay_bars");			// Global functions/variables related to the system 'COB'
	::include("mod_URUI/system/highlight_blocked_tiles");		// Global functions/variables related to the system 'HBT'
	::include("mod_URUI/system/roster_warning_icon");			// Global functions/variables related to the system 'RWI'
	::include("mod_URUI/system/summarized_mood_icon");			// Global functions/variables related to the system 'SMI'
	::include("mod_URUI/system/useful_item_filter");			// Global functions/variables related to the system 'UIF'

	::include("mod_URUI/msu_settings");							// generate all msu mod settings
});
