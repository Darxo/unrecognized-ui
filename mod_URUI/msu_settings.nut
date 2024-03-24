
// Combat Overlay Setting Page
{
	local combatOverlayPage = ::modURUI.Mod.ModSettings.addPage("Combat Overlay");

	// My class that applies all the option changes hooks into the setDirty function of the actor
	local genericCallback = function( _oldValue )
	{
		if (!::MSU.Utils.hasState("tactical_state")) return;    // At the start of any combat a 'fullUIUpdate' will be called anyways so we dont need to do that preemtively
		if (this.Value == _oldValue) return;    // Value didn't change. We don't need an update
		local allEntities = ::Tactical.Entities.getAllInstancesAsArray();
		foreach(entity in allEntities)
		{
			entity.getCustomOverlayBars().fullUIUpdate();
		}
	}

	// Default colors that should mimic the HP and Armor
	local helmetColor = "128,128,128,1.0";
	local chestColor = "128,128,128,1.0";
	local healthColor =  "255,0,0,1.0";
	local helmetColor = "128,128,128,1.0";  // Grey
	local chestColor = "128,128,128,1.0";   // Grey
	local healthColor =  "255,0,0,1.0";     // Red

	// Color-Setings for Helmet, Chest, Allies and Enemies
	local helmetColorSetting = combatOverlayPage.addColorPickerSetting("HelmetBarColor", helmetColor, "Color of the Head Armour Bar");
	helmetColorSetting.addAfterChangeCallback(genericCallback);
	local chestColorSetting = combatOverlayPage.addColorPickerSetting("ChestBarColor", chestColor, "Color of the Body Armour Bar");
	chestColorSetting.addAfterChangeCallback(genericCallback);
	local allyHealthColorSetting = combatOverlayPage.addColorPickerSetting("AllyHealthBarColor", healthColor, "Color of Ally Health Bar");
	allyHealthColorSetting.addAfterChangeCallback(genericCallback);
	local enemyHealthColorSetting = combatOverlayPage.addColorPickerSetting("EnemyHealthBarColor", healthColor, "Color of Enemy Health Bar");
	enemyHealthColorSetting.addAfterChangeCallback(genericCallback);

	// Overlay Size
	local overlaySizeSetting = combatOverlayPage.addRangeSetting("OverlaySize", 100, 60, 300, 2, "Overlay Size", "The Overlay Bars and Icons are scaled to this value in percent. 100% is the vanilla size.");
	overlaySizeSetting.addAfterChangeCallback(genericCallback);

	// Overlay Vertical Offset
	local verticalOffsetSetting = combatOverlayPage.addRangeSetting("VerticalOffset", 0, -60, 60, 2, "Vertical Offset", "Defines how high or low the Overlay Bars and Icons are drawn above the actor.");
	verticalOffsetSetting.addAfterChangeCallback(genericCallback);

	// Overlay Display Mode
	local displayModeCallback = function( _oldValue )
	{
		if (!::MSU.Utils.hasState("tactical_state")) return;
		::Tactical.State.m.TacticalScreen.getTopbarOptionsModule().setToggleStatsOverlaysButtonState(this.getValue());
		genericCallback(_oldValue);
	}
	local myEnumBarSetting = combatOverlayPage.addEnumSetting("OverlayDisplayMode", ::modURUI.COB.OnlyWhileDamaged.Setting, [::modURUI.COB.OnlyWhileDamaged.Setting, ::modURUI.COB.NeverShow.Setting, ::modURUI.COB.AlwaysShow.Setting], "Overlay Display Mode", "Controls how and when the complete combat overlay on the entities during a battle are shown.");
	myEnumBarSetting.addAfterChangeCallback(displayModeCallback);

	// Overlay Icon Alpha
	local iconAlphaSetting = combatOverlayPage.addRangeSetting("IconAlpha", 255, 0, 255, 3, "Icon Alpha", "Defines the Transparency of the Mini Icons");
	iconAlphaSetting.addAfterChangeCallback(genericCallback);

	// Skin counts as Undamaged - Option
	local skinUnDamagedSetting = combatOverlayPage.addBooleanSetting("SkinCountsAsUnDamaged", true, "Skin counts as 'Full HP'", "An actor that has no armor but full health will be treated as 'Undamaged'. Otherwise enemies that naturally spawn with no armor (e.g. Ghouls) would always show their overlay.");
	skinUnDamagedSetting.addAfterChangeCallback(genericCallback);

	// Force Display Duration
	combatOverlayPage.addRangeSetting("ForceDisplayDuration", 4.0, 0.0, 8.0, 0.5, "Hit Display Duration", "An actor that just took damage will display their overlay for this duration disregarding other settings.");

	// Damaged Armor Threshold
	local armorThresholdSetting = combatOverlayPage.addRangeSetting("OverlayArmorThreshold", 100, 0, 100, 2, "Damaged Armor Threshold", "An actor counts as 'damaged' when either Head- or Body Armor is below this percentage.");
	armorThresholdSetting.addAfterChangeCallback(genericCallback);

	// Damaged Health Threshold
	local healthThresholdSetting = combatOverlayPage.addRangeSetting("OverlayHealthThreshold", 100, 20, 100, 2, "Damaged Health Threshold", "An actor counts as 'damaged' while their Health is below this percentage.");
	healthThresholdSetting.addAfterChangeCallback(genericCallback);
}

// Combat General
{
	local combatGeneralPage = ::modURUI.Mod.ModSettings.addPage("Combat - General");

	// Blocked Tiles Setting
	{
		local myEnumSetting = ::MSU.Class.EnumSetting(
			"BlockedTilesOptions",
			::modURUI.HBT.HighlightOption.Both,
			[::modURUI.HBT.HighlightOption.Both, ::modURUI.HBT.HighlightOption.Custom, ::modURUI.HBT.HighlightOption.Vanilla],
			"Highlight Options for Blocked Tiles",
			"Control which highlight modes for blocked tiles should be available. Choosing a specific mode improves the toggling during battle."
		);
		combatGeneralPage.addElement(myEnumSetting);
	}

	combatGeneralPage.addDivider("CombatGeneralDivider1");
	// Round Information Setting
	{
		local genericCallback = function( _oldValue )
		{
			if (!::MSU.Utils.hasState("tactical_state")) return;
			if (this.Value == _oldValue) return;    // Value didn't change. We don't need an update
			::Tactical.TopbarRoundInformation.update();
		}

		local myAllyEnumSetting = ::MSU.Class.EnumSetting(
			"RoundInformationAllyNumber",
			"Brothers + Allies",
			["Brothers + Allies", "Total"],
			"Ally Entity Amount",
			"Controls how the amount of allies on the left side of the round information is displayed. \"Brothers + Allies\" will display the amount of your brothers separated from the amount of every other ally."
		);
		myAllyEnumSetting.addAfterChangeCallback(genericCallback);
		combatGeneralPage.addElement(myAllyEnumSetting);

		local myEnemyEnumSetting = ::MSU.Class.EnumSetting(
			"RoundInformationEnemyNumber",
			"Visible (Total)",
			["Visible (Total)", "Total"],
			"Enemy Entity Amount",
			"Controls how the amount of enemies on the right side of the round information is displayed. \"Visible (Total)\" will display the amount of enemies currently visible to you alongside the total amount."
		);
		myEnemyEnumSetting.addAfterChangeCallback(genericCallback);
		combatGeneralPage.addElement(myEnemyEnumSetting);
	}
}

// Filter Page
{
	local filterPage = ::modURUI.Mod.ModSettings.addPage("Item Filter");

	// Useful Item Filter
	local myBoolSetting = ::MSU.Class.BooleanSetting( "ResetItemFilterShop", true , "Reset Item Filter (Shop)", "Entering a Shop will always reset the Item Filter back to 'All'");
	filterPage.addElement(myBoolSetting);

	local myBoolSetting = ::MSU.Class.BooleanSetting( "ResetItemFilterCharacter", false , "Reset Item Filter (Char-Screen)", "Opening your character screen will always reset the Item Filter back to 'All'");
	filterPage.addElement(myBoolSetting);

	local myBoolSetting = ::MSU.Class.BooleanSetting( "ApplyItemFilterToShops", true , "Filter Shop Items", "Inventories of Shops are affected by the current Item Filter");
	filterPage.addElement(myBoolSetting);
}

// Misc Page
{
	local miscPage = ::modURUI.Mod.ModSettings.addPage("Misc");

	// Custom Thresholds for the old HP Icon and the new Armor Icon
	miscPage.addRangeSetting("HPThreshold", 80, 0, 100, 5, "Hitpoint Threshold", "The hitpoint symbol will only be shown if the current health is below this threshold.");
	miscPage.addRangeSetting("ArmorThreshold", 80, 0, 100, 5, "Armor Threshold", "The armor symbol will only be shown if either the current head- or body armor is below this threshold.");

	// Should a missing armor spawn an Icon?
	miscPage.addBooleanSetting( "NotifyMissingPieces", true , "Notify on Missing Armor", "A brother who is not wearing a helmet or body armour will show the 'Missing-Armor-Symbol'");
	miscPage.addDivider("MiscDivider1");

	// Summarized Mood Icon
	local myEnumSetting = ::MSU.Class.EnumSetting("ShowMoodIcon", "Lowest Mood", ["Do not show", "Lowest Mood", "Average Mood"], "Show Mood Icon", "Displays a single mood icon on top of the roster button that summarizes the mood of all your brothers.");
	myEnumSetting.addAfterChangeCallback(function (_oldValue)
	{
		if (::MSU.Utils.getActiveState() == null) return;
		if (::MSU.Utils.getActiveState().ClassName == "main_menu_state") return;	// otherwise the game crashes when changing settings in main menu
		if (this.Value == _oldValue) return;    // Value didn't change. We don't need an update
		::World.State.updateTopbarAssets();
	});
	miscPage.addElement(myEnumSetting);
	miscPage.addDivider("MiscDivider2");


	// Fatigue/Initiative Attribute Display
	local myBoolSetting = ::MSU.Class.BooleanSetting( "DisplayBaseFatigue", false , "Display Base Fatigue", "While outside of combat: your current fatigue is now displayed as the blue part of the progress bar while your base fatigue will be its maximum.");
	miscPage.addElement(myBoolSetting);
	local myBoolSetting = ::MSU.Class.BooleanSetting( "DisplayBaseInitiative", false , "Display Base Initiative", "While outside of combat: your current initiative is now displayed as the yellow part of the progress bar while your base initiative will be its maximum.");
	miscPage.addElement(myBoolSetting);
	miscPage.addDivider("MiscDivider3");

	miscPage.addDivider("MiscDivider4");

	// Mod List
	{
		local generateModList = function()
		{
			::modURUI.generateModlist();
		}

		local genModListButton = miscPage.addButtonSetting("GenModListButton", false, "Generate Mod List", "Generate a list of all Mods which are currently registered via Modern Hooks, separated by semi colons. Vanilla Files, modern hooks, hooks and msu are excluded.");
		genModListButton.addCallback(generateModList);

		miscPage.addStringSetting("ModListOutput", "", "Mod List:");
	}
}


// MSU Keybinds
	// Useful Item Filter
	::modURUI.Mod.Keybinds.addJSKeybind("Filter1", "1", "Itemfilter - All", "Changes the current Filter to 'All' when pressed in the Inventory- or Shop Screen");
	::modURUI.Mod.Keybinds.addDivider("FilterDivider");
	::modURUI.Mod.Keybinds.addJSKeybind("Filter2", "2", "Itemfilter - Weapons", "Changes the current Filter to 'Weapons' when pressed in the Inventory- or Shop Screen");
	::modURUI.Mod.Keybinds.addJSKeybind("Filter3", "3", "Itemfilter - Armor", "Changes the current Filter to 'Armor' when pressed in the Inventory- or Shop Screen");
	::modURUI.Mod.Keybinds.addJSKeybind("Filter4", "4", "Itemfilter - Usable", "Changes the current Filter to 'Usable' when pressed in the Inventory- or Shop Screen");
	::modURUI.Mod.Keybinds.addJSKeybind("Filter5", "5", "Itemfilter - Misc", "Changes the current Filter to 'Misc' when pressed in the Inventory- or Shop Screen");
