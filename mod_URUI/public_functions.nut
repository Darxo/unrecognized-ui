// Roster Warning Icon
	/*
	Adds a function to an internal array that decides whether a warning icon is displayed on the roster buttons
	This warning is displayed when any of the added functions return true.

	@param _function Function with no parameter that returns true or false.
	@return null
	*/
	::modURUI.addRosterCheck <- function(_function)
	{
		::modURUI.RWI.RosterChecks.push(_function);
	}

	/*
	Adds a function to an internal array that decides whether a warning icon is displayed on the formation buttons
	This warning is displayed when any of the added functions return true.

	@param _function Function with no parameter that returns true or false.
	@return null
	*/
	::modURUI.addFormationCheck <- function(_function)
	{
		::modURUI.RWI.FormationChecks.push(_function);
	}

	/*
	Forces an update of the overlay to display recent changes regarding the warning Icons

	@return null
	*/
	::modURUI.forceUpdate <- function()
	{
		::modURUI.updateTopbarAssets();	// this causes a calculateWarnings call in order to update that FormationWarning variable
		if (::modURUI.Mod.ModSettings.getSetting("ShowRosterWarning").getValue())
		{
			::World.State.m.CharacterScreen.setWarning(::modURUI.RWI.FormationWarning);
		}
	}
