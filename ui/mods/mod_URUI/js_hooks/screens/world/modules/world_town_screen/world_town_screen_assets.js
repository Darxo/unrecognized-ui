

// Town Screen Hooks:
// Create two new container for overlaying the icons
var modURUI_WorldTownScreenAssets_createDIV = WorldTownScreenAssets.prototype.createDIV;
WorldTownScreenAssets.prototype.createDIV = function(_parentDiv)
{
	// console.error("createDIV Town Screen hook");
	modURUI_WorldTownScreenAssets_createDIV.call(this, _parentDiv);
	this.mMoodContainer = $('<div id="modular-notifications-moodcontainer"/>');
	this.mBrothersAsset.append(this.mMoodContainer);

	this.mWarningContainer = $('<div id="modular-notifications-warningcontainer"/>');
	this.mWarningContainer.append($('<img src="' + Path.GFX + 'ui/icons/warning.png' + '"/>'));
	this.mBrothersAsset.append(this.mWarningContainer);
};

// Append the respective Icons into those container when the DataSource says so
var modURUI_WorldTownScreenAssets_loadFromData = WorldTownScreenAssets.prototype.loadFromData;
WorldTownScreenAssets.prototype.loadFromData = function(_data)
{
	// console.error("updateAssetValue hook");
	modURUI_WorldTownScreenAssets_loadFromData.call(this, _data);

	this.mWarningContainer.removeClass('display-block').addClass('display-none');
	// this.mWarningContainer.empty();
	if (_data["RosterWarning"] === true || _data["FormationWarning"] === true)
	{
		this.mWarningContainer.removeClass('display-none').addClass('display-block');
		// this.mWarningContainer.append($('<img src="' + Path.GFX + 'ui/icons/warning.png' + '"/>'));
	}

	this.mMoodContainer.empty();
	if (_data['RosterMood'] !== "")
	{
		this.mMoodContainer.append($('<img src="' + Path.GFX + _data['RosterMood'] + '"/>'));
	}
}
