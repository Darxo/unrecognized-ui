::modURUI.SMI <- {
	// Const
	MoodStateIconPath = [
		"ui/icons/mood_01.png",
		"ui/icons/mood_02.png",
		"ui/icons/mood_03.png",
		"ui/icons/mood_04.png",
		"ui/icons/mood_05.png",
		"ui/icons/mood_06.png",
		"ui/icons/mood_07.png"
	]

	// Global
	RosterMood = "",		// "" means no Mood should be displayed
}

::modURUI.SMI.calculateRosterMood <- function()
{
	local settingOption = ::modURUI.Mod.ModSettings.getSetting("ShowMoodIcon").getValue();
	if (settingOption == "Do not show")
	{
		::modURUI.SMI.RosterMood = "";
	}
	else
	{
		local lowestMoodState = ::Const.MoodState.Euphoric;
		// local highestMoodState = ::Const.MoodState.Angry;
		local combinedMood = 0.0;

		local roster = ::World.getPlayerRoster().getAll();
		foreach( bro in roster )
		{
			combinedMood += bro.getMoodState();

			if (bro.getMoodState() < lowestMoodState) lowestMoodState = bro.getMoodState();
			// if (bro.getMoodState() > highestMoodState) highestMoodState = bro.getMoodState();
		}

		if (settingOption == "Lowest Mood") ::modURUI.SMI.RosterMood = ::modURUI.SMI.MoodStateIconPath[lowestMoodState];
		// else if (settingOption == "Highest Mood") ::modURUI.RosterMood = ::modURUI.SMI.MoodStateIconPath[highestMoodState];
		else if (settingOption == "Average Mood") ::modURUI.SMI.RosterMood = ::modURUI.SMI.MoodStateIconPath[::Math.floor(combinedMood / roster.len())];
	}
}
