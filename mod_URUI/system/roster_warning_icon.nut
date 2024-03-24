// Deprecated - This Feature is a bit awkward in practice and needs much more though before offering it as a framework for others to use
// For now it's just not advertised but still in code

/*
The feature for Roster Warning Icons adds the ability for other mods to warn the player via a Warning-Icon on the Roster-Button in the World/Town Screen
Other mods need to call a public function from this mod for that and register a function.
*/

::modURUI.RWI <- {
	//Global
	RosterWarning = false,		// Is shown in WorldScreen and TownScreen
	FormationWarning = false,	// Is shown in WorldScreen and CharacterScreen
	RosterChecks = [],		// List of functions that return true/false
	FormationChecks = []	// List of functions that return true/false
}

::modURUI.RWI.calculateWarnings <- function()
{
	//  if (::Tactical.State != null && ::Tactical.State.isScenarioMode()) return;
	::modURUI.RWI.checkRosterWarnings();
	::modURUI.RWI.checkFormationWarnings();
}

// Iterates through all warningFunctions added by other mods to find out of any of them produce a true
::modURUI.RWI.checkRosterWarnings <- function()
{
	::modURUI.RWI.RosterWarning = false;
	if (!("Assets" in ::World) || ::World.Assets == null || ::World.Assets.getOrigin() == null) return;
	foreach (rosterCheck in ::modURUI.RWI.RosterChecks)
	{
		if (rosterCheck())
		{
			::modURUI.RWI.RosterWarning = true;
			break;
		}
	}
}

// Iterates through all warningFunctions added by other mods to find out of any of them produce a true
::modURUI.RWI.checkFormationWarnings <- function()
{
	::modURUI.RWI.FormationWarning = false;
	if (!("Assets" in ::World) || ::World.Assets == null || ::World.Assets.getOrigin() == null) return;
	foreach (formationCheck in ::modURUI.RWI.FormationChecks)
	{
		if (formationCheck())
		{
			::modURUI.RWI.FormationWarning = true;
			break;
		}
	}
}
