// Initialise mod related java namespace with constants/variables/functions
::Hooks.registerJS("ui/mods/mod_URUI/assets.js");

// Implements the Armor/HP Threshold Icons
// Handles creation and update of Roster Warning Icon on the roster label
::Hooks.registerJS("ui/mods/mod_URUI/brothers.js");
::Hooks.registerJS("ui/mods/mod_URUI/screens/character/modules/character_screen_brothers_list/character_screen_brothers_list_module.js");

// Collection of different JS Hooks to implement the Summarized Mood Icon & Roster Warning Icon feature
::Hooks.registerCSS("ui/mods/mod_URUI/css/custom_icons.css");

// Overwrites the vanilla Show/Hide Overlay Bars button that's shown during combat
::Hooks.registerJS("ui/mods/mod_URUI/topbar_options_module.js");

// Switches out the skin for an active button of size 3 (filter buttons)
::Hooks.registerCSS("ui/mods/mod_URUI/css/button.css");

// Apply all filter improvements for shop screen
::Hooks.registerJS("ui/mods/mod_URUI/screens/world/modules/world_town_screen/world_town_screen_shop_dialog_module.js");
::Hooks.registerCSS("ui/mods/mod_URUI/css/world_town_screen_shop_dialog_module.css");

// Apply all filter improvements for character inventory screen
// Adds a from the outside callable function for setting the Roster Warning Icon
::Hooks.registerJS("ui/mods/mod_URUI/screens/character/modules/character_screen_right_panel/character_screen_inventory_list_module.js");
::Hooks.registerJS("ui/mods/mod_URUI/screens/character/character_screen_datasource.js");
::Hooks.registerCSS("ui/mods/mod_URUI/css/character_screen_datasource.css");

// Town Screen Hooks for Summarized Mood Icon & Roster Warning Icon
::Hooks.registerJS("ui/mods/mod_URUI/screens/world/modules/world_town_screen/world_town_screen_assets.js");

// World Screen Hooks for Summarized Mood Icon & Roster Warning Icon
::Hooks.registerJS("ui/mods/mod_URUI/screens/world/modules/world_screen_topbar/world_screen_topbar_options_module.js");

// Stats-Module hook for displaying the base Initiative
::Hooks.registerJS("ui/mods/mod_URUI/screens/character/modules/character_screen_left_panel/character_screen_stats_module.js");


