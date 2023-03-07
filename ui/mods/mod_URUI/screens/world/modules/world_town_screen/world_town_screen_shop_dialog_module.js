var modURUI_WorldTownScreen_createDIV = WorldTownScreenShopDialogModule.prototype.createDIV;
WorldTownScreenShopDialogModule.prototype.createDIV = function (_parentDiv)
{
	modURUI_WorldTownScreen_createDIV.call(this, _parentDiv);

	var container = this.mDialogContainer.findDialogContentContainer();
	buttonContainer = container.children(".column.is-middle").children(".row.is-content").children(".button-container");
	var layout = $('<div class="l-button hide-empty-slots-button"/>');

	buttonContainer.append(layout);
	var self = this;
    var image;
    if (modURUI.SHOW_EMPTY_SLOTS_SHOP)
    {
        image = Path.GFX + modURUI.BUTTON_SHOW_EMPTY_SLOTS;
    }
    else
    {
        image = Path.GFX + modURUI.BUTTON_HIDE_EMPTY_SLOTS;
    }
	this.mHideEmptySlotsButton = layout.createImageButton(image, function()
	{
        if (modURUI.SHOW_EMPTY_SLOTS_SHOP === true)
        {
            self.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_HIDE_EMPTY_SLOTS);
            modURUI.SHOW_EMPTY_SLOTS_SHOP = false;
        }
        else
        {
            self.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_SHOW_EMPTY_SLOTS);
            modURUI.SHOW_EMPTY_SLOTS_SHOP = true;
        }
        self.applyItemFilter(self.mCurrentFilter, false);
	}, '', 3);

    if (this.mCurrentFilter !== undefined && MSU.getSettingValue("mod_URUI", "ResetItemFilterShop") === true)
    {
        this.mCurrentFilter = this.Filter1;
    }

    // Item Filter Hotkeys
    // this.mContainer  $(document)
    $(document).on('keyup.' + modURUI.ID + 'CS', null, this, function (_event)
    {
        if (self.isVisible() == false) return false;

        var ret = false;
        if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter1", _event))
        {
            if (self.mCurrentFilter !== self.mFilter1) self.mFilterAllButton.click();
            ret = true;
        }
        else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter2", _event))
        {
            if (self.mCurrentFilter !== self.mFilter2) self.mFilterWeaponsButton.click();
            else self.mFilterAllButton.click();
            ret = true;
        }
        else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter3", _event))
        {
            if (self.mCurrentFilter !== self.mFilter3) self.mFilterArmorButton.click();
            else self.mFilterAllButton.click();
            ret = true;
        }
        else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter4", _event))
        {
            if (self.mCurrentFilter !== self.mFilter4) self.mFilterUsableButton.click();
            else self.mFilterAllButton.click();
            ret = true;
        }
        else if (MSU.Keybinds.isKeybindPressed(modURUI.ID, "Filter5", _event))
        {
            if (self.mCurrentFilter !== self.mFilter5) self.mFilterMiscButton.click();
            else self.mFilterAllButton.click();
            ret = true;
        }

        return ret;
    });
};

// We read out the exact configurations of the Filter one time. We don't expect them to ever change while inside the market screen
var modAUF_WorldTownScreenShopDialogModule_loadFromData = WorldTownScreenShopDialogModule.prototype.loadFromData;
WorldTownScreenShopDialogModule.prototype.loadFromData = function( _data )
{
    modAUF_WorldTownScreenShopDialogModule_loadFromData.call(this, _data);
    if(_data === undefined || _data === null || !(typeof(_data) === 'object')) return;

    if ('Filter1' in _data) this.mFilter1 = _data.Filter1;
    if ('Filter2' in _data) this.mFilter2 = _data.Filter2;
    if ('Filter3' in _data) this.mFilter3 = _data.Filter3;
    if ('Filter4' in _data) this.mFilter4 = _data.Filter4;
    if ('Filter5' in _data) this.mFilter5 = _data.Filter5;

    if (this.mCurrentFilter === undefined)  // We don't need to apply filtering on opening the shop for the actual very first time in this game
    {
        this.mCurrentFilter = _data.Filter1;
        this.applyItemFilter(this.mCurrentFilter, true);    // improves inheritance of shop-module when first time opening them
    }
    else
    {
        if (MSU.getSettingValue("mod_URUI", "ResetItemFilterShop") === true)
        {
            // Another button could have still been highlighted so we correct that and also reapply the SlotHiding setting at the same time.
            this.mFilterAllButton.click();
        }
        else
        {
            // So that reopening the shop screen reapplies the previously used filter
            this.applyItemFilter(this.mCurrentFilter, true);
        }
    }
}

var modAUF_WorldTownScreenShopDialogModule_updateSlotItem = WorldTownScreenShopDialogModule.prototype.updateSlotItem;
WorldTownScreenShopDialogModule.prototype.updateSlotItem = function (_owner, _itemArray, _item, _index, _flag)
{
    modAUF_WorldTownScreenShopDialogModule_updateSlotItem.call(this, _owner, _itemArray, _item, _index, _flag);
    if (_owner === WorldTownScreenShop.ItemOwner.Shop) return;  // We do Shop filtering in the updateShopList function because only then is 'mShopList' up to date
    this.filterSingleItem(_index, this.mCurrentFilter, true);
}

// Removing an item from the shop makes all other items move up one position. So many of out slots dont have the correct visibility anymore acording to their new item
var modAUF_WorldTownScreenShopDialogModule_updateShopList = WorldTownScreenShopDialogModule.prototype.updateShopList
WorldTownScreenShopDialogModule.prototype.updateShopList = function (_data)
{
    modAUF_WorldTownScreenShopDialogModule_updateShopList.call(this, _data);
    if (MSU.getSettingValue("mod_URUI", "ApplyItemFilterToShops") === false) return;
    for( var i = 0; i < this.mShopSlots.length; i = ++i )
    {
        this.filterSingleItem(i, this.mCurrentFilter, false);
    }
}

WorldTownScreenShopDialogModule.prototype.filterSingleItem = function(_itemIndex, _filter, _isPlayerStash)
{
    var itemList = this.mShopList;
    var itemSlots = this.mShopSlots;
    if (_isPlayerStash)
    {
        itemList = this.mStashList;
        itemSlots = this.mStashSlots;
    }

    if (itemList[_itemIndex] === undefined)     // This is mostly important for Shops. Them gaining slots breaks this filter otherwise
    {
        if (modURUI.SHOW_EMPTY_SLOTS_SHOP) modURUI.showSlot(itemSlots[_itemIndex]);
        else modURUI.hideSlot(itemSlots[_itemIndex]);
        return;
    }

    if (itemList[_itemIndex] === null && modURUI.SHOW_EMPTY_SLOTS_SHOP )
    {
        modURUI.showSlot(itemSlots[_itemIndex]);
        return;
    }

    // Special rule to make sure no item is ever hidden.
    // Some new itemtypes may not have been put into the Filter1 (All) yet. Or maybe there are items with no itemtype?
    if (itemList[_itemIndex] !== null && _filter === this.mFilter1)
    {
        modURUI.showSlot(itemSlots[_itemIndex]);
        return;
    }

    if ((itemList[_itemIndex] !== null) && ((itemList[_itemIndex].type & _filter) !== 0))
    {   // the item i exists and matches the filter:
        modURUI.showSlot(itemSlots[_itemIndex]);
    }
    else
    {   // the item i does not exist or it does not match the filter:
        modURUI.hideSlot(itemSlots[_itemIndex]);
    }
}

// New helper function to apply a filter by hiding the Itemslot-Container
WorldTownScreenShopDialogModule.prototype.applyItemFilter = function(_filter, _scrollTop)
{
    this.mCurrentFilter = _filter;
    // Apply to player inventory
    for( var i = 0; i < this.mStashSlots.length; i = ++i )
    {
        this.filterSingleItem(i, _filter, true);
    }
    // Of all the solutions I found online on how to set the scroll position this was the one that worked
    if (_scrollTop) this.mStashListContainer.trigger('scroll', { element: this.mStashSlots[0], scrollTo: 'top' });

    if (MSU.getSettingValue("mod_URUI", "ApplyItemFilterToShops") === false) return;
    // Apply to shop inventory
    for( var i = 0; i < this.mShopSlots.length; i = ++i )
    {
        this.filterSingleItem(i, _filter, false);
    }
    if (_scrollTop) this.mShopListContainer.trigger('scroll', { element: this.mShopSlots[0], scrollTo: 'top' });
}

// Registering of the tooltip of your new button
var modURUI_WorldTownScreen_bindTooltips = WorldTownScreenShopDialogModule.prototype.bindTooltips;
WorldTownScreenShopDialogModule.prototype.bindTooltips = function ()
{
	modURUI_WorldTownScreen_bindTooltips.call(this);
	this.mHideEmptySlotsButton.bindTooltip({ contentType: 'msu-generic', modId: modURUI.ID, elementId:  'TownShopDialogModule.ToggleSlotVisibility' });
};

var modURUI_WorldTownScreen_unbindTooltips = WorldTownScreenShopDialogModule.prototype.unbindTooltips;
WorldTownScreenShopDialogModule.prototype.unbindTooltips = function ()
{
	modURUI_WorldTownScreen_unbindTooltips.call(this);
	this.mHideEmptySlotsButton.unbindTooltip();
};

var modURUI_WorldTownScreenShopDialogModule_show = WorldTownScreenShopDialogModule.prototype.show;
WorldTownScreenShopDialogModule.prototype.show = function (_withSlideAnimation)
{
    // This module is usually able to remember this option image in between opening and closing
    // But a mod may introduce a new module which inherits the behavior of the shop module. For that purpose we make sure that this button is updated
    if (modURUI.SHOW_EMPTY_SLOTS_SHOP)
    {
        this.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_SHOW_EMPTY_SLOTS);
    }
    else
    {
        this.mHideEmptySlotsButton.changeButtonImage(Path.GFX + modURUI.BUTTON_HIDE_EMPTY_SLOTS);
    }
	modURUI_WorldTownScreenShopDialogModule_show.call(this, _withSlideAnimation);
};


// Overwrites of the vanilla filter notifies. We redirect them to apply the filtering locally
WorldTownScreenShopDialogModule.prototype.notifyBackendFilterAllButtonClicked = function ()
{
    this.applyItemFilter(this.mFilter1, true);
};

WorldTownScreenShopDialogModule.prototype.notifyBackendFilterWeaponsButtonClicked = function ()
{
    this.applyItemFilter(this.mFilter2, true);
};

WorldTownScreenShopDialogModule.prototype.notifyBackendFilterArmorButtonClicked = function ()
{
    this.applyItemFilter(this.mFilter3, true);
};

WorldTownScreenShopDialogModule.prototype.notifyBackendFilterUsableButtonClicked = function ()
{
    this.applyItemFilter(this.mFilter4, true);
};

WorldTownScreenShopDialogModule.prototype.notifyBackendFilterMiscButtonClicked = function ()
{
    this.applyItemFilter(this.mFilter5, true);
};

