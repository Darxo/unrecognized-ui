
var modURUI_CharacterScreenBrothersListModule_updateBrotherSlot = CharacterScreenBrothersListModule.prototype.updateBrotherSlot;
CharacterScreenBrothersListModule.prototype.updateBrotherSlot = function(_data)
{

	var oldHealth = _data['stats'].hitpoints;
	_data['stats'].hitpoints = _data['stats'].hitpointsMax;     // We pretend the HP is full so that the original icon is not shown
	modURUI_CharacterScreenBrothersListModule_updateBrotherSlot.call(this, _data);
	_data['stats'].hitpoints = oldHealth;

	// Replicate Vanilla exit condition
	var slot = this.mListScrollContainer.find('#slot-index_' + _data[CharacterScreenIdentifier.Entity.Id] + ':first');
	if (slot.length === 0)
	{
		return;
	}

	if (_data['injuries'].length <= 2)	// Vanilla only displays the health icon when there are 2 or fewer injuries to display. We do the same
	{
		var hpSetting = MSU.getSettingValue("mod_URUI", "HPThreshold");
		var hpThreshold = hpSetting * (_data['stats'].hitpointsMax / 100.0);
		var armorSetting = MSU.getSettingValue("mod_URUI", "ArmorThreshold");
		var headThreshold = armorSetting * (_data['stats'].armorHeadMax / 100.0);
		var bodyThreshold = armorSetting * (_data['stats'].armorBodyMax / 100.0);
		var hitPointBool = _data['stats'].hitpoints <= hpThreshold;
		var armourBool = (_data['stats'].armorHead < headThreshold) || (_data['stats'].armorBody < bodyThreshold);
		var missingArmorBool = (_data['stats'].armorHeadMax == 0 || _data['stats'].armorBodyMax == 0) && MSU.getSettingValue("mod_URUI", "NotifyMissingPieces");
		if(hitPointBool)
		{
			if(armourBool || missingArmorBool)
			{
				slot.assignListBrotherHybrid('ui/icons/days_wounded+armor_body.png');
			}
			else
			{
				slot.assignListBrotherHybrid(Asset.ICON_DAYS_WOUNDED);
			}

		}
		else if (armourBool || missingArmorBool)
		{
			slot.assignListBrotherHybrid(Asset.ICON_ARMOR_BODY);
		}
	}
};

var modURUI_CharacterScreenBrothersListModule_addBrotherSlotDIV = CharacterScreenBrothersListModule.prototype.addBrotherSlotDIV;
CharacterScreenBrothersListModule.prototype.addBrotherSlotDIV = function (_parentDiv, _data, _index, _allowReordering)
{
	// This is the second time that vanilla calls "assignListBrotherDaysWounded" so we need to apply our own highlighting method also right after
	modURUI_CharacterScreenBrothersListModule_addBrotherSlotDIV.call(this, _parentDiv, _data, _index, _allowReordering);
	this.updateBrotherSlot(_data);
}

// Character Screen Hooks:
// Create one new container for overlaying the icons
var modURUI_CharacterScreenBrothersListModule_createDiv = CharacterScreenBrothersListModule.prototype.createDIV;
CharacterScreenBrothersListModule.prototype.createDIV = function (_parentDiv)
{
	modURUI_CharacterScreenBrothersListModule_createDiv.call(this, _parentDiv);

	// This has a special style because mRosterCountContainer has an ugly overflowing width. I rather just render my warning top left here and don't have to care with that.
	this.mWarningContainer = $('<div id="modular-notifications-warningcontainer-character-screen"/>');
	this.mWarningContainer.append($('<img src="' + Path.GFX + 'ui/icons/warning.png' + '"/>'));
	this.mRosterCountContainer.append(this.mWarningContainer);
}

// Append the respective Icon into that container when the new mBrothersWarning variable says so
var modURUI_CharacterScreenBrothersListModule_updateRosterLabel = CharacterScreenBrothersListModule.prototype.updateRosterLabel;
CharacterScreenBrothersListModule.prototype.updateRosterLabel = function ()
{
	modURUI_CharacterScreenBrothersListModule_updateRosterLabel.call(this);

	this.mWarningContainer.removeClass('display-block').addClass('display-none');
	if (this.mDataSource.mFormationWarning === true) // No roster warning in town screen
	{
		this.mWarningContainer.removeClass('display-none').addClass('display-block');
	}
};
