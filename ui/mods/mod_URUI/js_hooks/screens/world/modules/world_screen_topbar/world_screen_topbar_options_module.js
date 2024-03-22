// World Screen Hooks:

// Create two new container for overlaying the icons
var modURUI_WorldScreenTopbarOptionsModule_createDIV = WorldScreenTopbarOptionsModule.prototype.createDIV;
WorldScreenTopbarOptionsModule.prototype.createDIV = function(_parentDiv)
{
	var ret = modURUI_WorldScreenTopbarOptionsModule_createDIV.call(this, _parentDiv);
	this.mMoodContainer = $('<div id="modular-notifications-moodcontainer"/>');
	this.mBrothersButton.append(this.mMoodContainer);

	this.mWarningContainer = $('<div id="modular-notifications-warningcontainer"/>');
	this.mWarningContainer.append($('<img src="' + Path.GFX + 'ui/icons/warning.png' + '"/>'));
	this.mBrothersButton.append(this.mWarningContainer);
	return ret;
};

// TUrn the Warning on/off depending on what the data source says
// Append the respective Mood Icons into those container when the DataSource says so
var modURUI_WorldScreenTopbarOptionsModule_updateAssetValue = WorldScreenTopbarOptionsModule.prototype.updateAssetValue;
WorldScreenTopbarOptionsModule.prototype.updateAssetValue = function(_data, _valueKey, _valueMaxKey, _button)
{
	modURUI_WorldScreenTopbarOptionsModule_updateAssetValue.call(this, _data, _valueKey, _valueMaxKey, _button);
	if(_button !== this.mBrothersButton) return;

	this.mWarningContainer.removeClass('display-block').addClass('display-none');
	if (_data.current["RosterWarning"] === true || _data.current["FormationWarning"] === true)
	{
		this.mWarningContainer.removeClass('display-none').addClass('display-block');
	}

	this.mMoodContainer.empty();
	if (_data.current['RosterMood'] !== "")
	{
		this.mMoodContainer.append($('<img src="' + Path.GFX + _data.current['RosterMood'] + '"/>'));
	}
}
