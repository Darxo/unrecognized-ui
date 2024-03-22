::includeFiles(::IO.enumerateFiles("mod_URUI/hooks"));		// run all squirrel hooks

::include("mod_URUI/private_functions");					// globally accessible but private functions
::include("mod_URUI/public_functions");						// Functions meant to be called by other mods

::includeFiles(::IO.enumerateFiles("mod_URUI/system"));		// Global functions/variables related to different internal systems

::include("mod_URUI/msu_settings");							// generate all msu mod settings
