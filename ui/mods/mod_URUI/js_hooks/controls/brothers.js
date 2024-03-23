{
	// New Functions that works exactly like "assignListBrotherDaysWounded" but allows you to pass a custom image
	$.fn.assignListBrotherHybrid = function( _iconPath )
	{
		var layer = this.find('.asset-layer:first');

		if (layer.length > 0)
		{
			var statusContainer = layer.find('.status-container:first');
			var statusImage = $('<img/>');
			statusImage.attr('src', Path.GFX + _iconPath);
			statusContainer.append(statusImage);
			layer.append(statusContainer);

			statusImage.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalCombatResultScreen.StatisticsPanel.DaysWounded });
		}
	}
}
