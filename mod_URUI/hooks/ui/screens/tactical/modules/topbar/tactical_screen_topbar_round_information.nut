::modURUI.HooksMod.hook("scripts/ui/screens/tactical/modules/topbar/tactical_screen_topbar_round_information", function(q) {
	q.m.LastBrothersCount <- null;
	q.m.LastEnemiesCount <- null;

// New Functions
	q.refreshTopbarIfChanged <- function()
	{
		local topBarInfo = this.m.OnQueryRoundInformationListener();

		if (topBarInfo.brothersCount == this.m.LastBrothersCount && topBarInfo.enemiesCount == this.m.LastEnemiesCount)
		{
			return;
		}

		this.m.LastBrothersCount = topBarInfo.brothersCount;
		this.m.LastEnemiesCount = topBarInfo.enemiesCount;
		this.m.JSHandle.asyncCall("update", topBarInfo);
	}
});
