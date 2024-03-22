::modURUI.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
// New Functions
	q.getVisibleHostilesNum <- function()
	{
		local visibleEnemies = 0;

		for (local i = 0; i != ::World.FactionManager.getFactions().len(); ++i)
		{
			if (!::World.FactionManager.isAlliedWithPlayer(i))
			{
				foreach (entity in this.m.Instances[i])
				{
					if (entity.isPlacedOnMap() && entity.getTile().IsVisibleForPlayer)
					{
						visibleEnemies++;
					}
				}
			}
		}

		return visibleEnemies;
	}
});
