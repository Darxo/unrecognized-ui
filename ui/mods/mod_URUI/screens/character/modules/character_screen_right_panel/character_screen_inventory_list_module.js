
// Create the new Slot-Visibility Button for the character screen
var modURUI_CharacterScreenInventoryListModule_createDIV = CharacterScreenInventoryListModule.prototype.createDIV;
CharacterScreenInventoryListModule.prototype.createDIV = function (_parentDiv)
{
	modURUI_CharacterScreenInventoryListModule_createDIV.call(this, _parentDiv);

	var layout = $('<div class="l-button hide-empty-slots-button"/>');
	this.mFilterPanel.append(layout);

	var image;
	if (modURUI.SHOW_EMPTY_SLOTS_CHARACTER_SCREEN)
	{
		image = Path.GFX + modURUI.BUTTON_SHOW_EMPTY_SLOTS;
	}
	else
	{
		image = Path.GFX + modURUI.BUTTON_HIDE_EMPTY_SLOTS;
	}
	var self = this;
	this.mHideEmptySlotsButton = layout.createImageButton(image, function()
	{
		if (modURUI.SHOW_EMPTY_SLOTS_CHARACTER_SCREEN === true)
		{
			self.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_HIDE_EMPTY_SLOTS);
			modURUI.SHOW_EMPTY_SLOTS_CHARACTER_SCREEN = false;
		}
		else
		{
			self.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_SHOW_EMPTY_SLOTS);
			modURUI.SHOW_EMPTY_SLOTS_CHARACTER_SCREEN = true;
		}
		self.mDataSource.applyItemFilter(self.mDataSource.mCurrentFilter, false);
	}, '', 3);

	// Item Filter Hotkeys
	$(document).on('keyup.' + modURUI.ID + 'CS', null, this, function (_event)
	{
		if (self === null) return false;
		if (self.mContainer === null) return false;
		if (self.isVisible() === false) return false;/*
		if (self.mDataSource === null) return false;
		if (self.mDataSource.isInStashMode === undefined) return false;     // Somehow that first condition isn't enough during battles.
		if (self.mDataSource.isInStashMode() === false) return false;   // Somehow that first condition isn't enough during battles.
*/
		var ret = false;
		if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter1", _event))
		{
			if (self.mDataSource.mCurrentFilter !== self.mDataSource.mFilter1) self.mFilterAllButton.click();
			ret = true;
		}
		else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter2", _event))
		{
			if (self.mDataSource.mCurrentFilter !== self.mDataSource.mFilter2) self.mFilterWeaponsButton.click();
			else self.mFilterAllButton.click();
			ret = true;
		}
		else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter3", _event))
		{
			if (self.mDataSource.mCurrentFilter !== self.mDataSource.mFilter3) self.mFilterArmorButton.click();
			else self.mFilterAllButton.click();
			ret = true;
		}
		else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter4", _event))
		{
			if (self.mDataSource.mCurrentFilter !== self.mDataSource.mFilter4) self.mFilterUsableButton.click();
			else self.mFilterAllButton.click();
			ret = true;
		}
		else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter5", _event))
		{
			if (self.mDataSource.mCurrentFilter !== self.mDataSource.mFilter5) self.mFilterMiscButton.click();
			else self.mFilterAllButton.click();
			ret = true;
		}

		return ret;
	});
};

// Bind tooltips for the new Slot-Visibility Button
var modURUI_CharacterScreenInventoryListModule_bindTooltips = CharacterScreenInventoryListModule.prototype.bindTooltips;
CharacterScreenInventoryListModule.prototype.bindTooltips = function ()
{
	modURUI_CharacterScreenInventoryListModule_bindTooltips.call(this);
	this.mHideEmptySlotsButton.bindTooltip({ contentType: 'msu-generic', modId: modURUI.ID, elementId:  'CharacterScreenInventoryListModule.ToggleSlotVisibility' });
};

var modURUI_CharacterScreenInventoryListModule_unbindTooltips = CharacterScreenInventoryListModule.prototype.unbindTooltips;
CharacterScreenInventoryListModule.prototype.unbindTooltips = function ()
{
	modURUI_CharacterScreenInventoryListModule_unbindTooltips.call(this);
	this.mHideEmptySlotsButton.unbindTooltip();
};
