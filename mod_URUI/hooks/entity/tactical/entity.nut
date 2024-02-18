// We need this hook because we want assign custom sprite after most/all other initialisations are done so that are drawn over everything else
::modURUI.HooksMod.hookTree("scripts/entity/tactical/entity", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		::modURUI.HBT.generateSingleOverlay(this);
	}
});
