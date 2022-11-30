// We read out the exact configurations of the Filter one time. We don't expect them to ever change while inside the market screen
var modAUF_CharacterScreenDatasourceloadFromData = CharacterScreenDatasource.prototype.loadFromData;
CharacterScreenDatasource.prototype.loadFromData = function( _data )
{
    modAUF_CharacterScreenDatasourceloadFromData.call(this, _data);
    if (_data === undefined || _data == null || typeof(_data) !== 'object') return;

    if (this.isInStashMode() === false) return;     // We don't want any of the following to be executed during battle. Because the mStashList will be empty while mInventorySlots will have items inside

    // Read the RosterWarning variable out of the DataSource into the mFormationWarning variable because DataSource is only available here
    this.setWarning([_data["FormationWarning"], _data["FormationMaxSize"]]);

    if ('Filter1' in _data) this.mFilter1 = _data.Filter1;
    if ('Filter2' in _data) this.mFilter2 = _data.Filter2;
    if ('Filter3' in _data) this.mFilter3 = _data.Filter3;
    if ('Filter4' in _data) this.mFilter4 = _data.Filter4;
    if ('Filter5' in _data) this.mFilter5 = _data.Filter5;

    if (this.mCurrentFilter === undefined)  // We don't need to apply filtering on opening the inventory for the actual very first time in this game
    {
        this.mCurrentFilter = _data.Filter1;
    }
    else
    {
        if (MSU.getSettingValue("mod_URUI", "ResetItemFilterCharacter") === true)
        {
            // Another button could have still been highlighted so we correct that and also reapply the SlotHiding setting at the same time.
            this.mInventoryModule.mFilterAllButton.click();
        }
        else
        {
            // So that reopening the shop screen reapplies the previously used filter
            this.applyItemFilter(this.mCurrentFilter, true);
        }
    }
}

// This will apply the current filter to any itemslot whose items was removed or added
var modURUI_CharacterScreenDatasource_notifyEventListener = CharacterScreenDatasource.prototype.notifyEventListener;
CharacterScreenDatasource.prototype.notifyEventListener = function(_channel, _payload)
{
    modURUI_CharacterScreenDatasource_notifyEventListener.call(this, _channel, _payload);
    if (this.isInStashMode() === false) return;
    if (_channel !== CharacterScreenDatasourceIdentifier.Inventory.StashItemUpdated.Key) return;
    this.filterSingleItem(_payload['index'], this.mCurrentFilter);
};

CharacterScreenDatasource.prototype.filterSingleItem = function(_itemIndex, _filter)
{
    if (this.mStashList[_itemIndex] === null && modURUI.SHOW_EMPTY_SLOTS_CHARACTER_SCREEN)
    {
        modURUI.showSlot(this.mInventoryModule.mInventorySlots[_itemIndex]);
        return;
    }

    // Special rule to make sure no item is ever hidden.
    // Some new itemtypes may not have been put into the Filter1 (All) yet. Or maybe there are items with no itemtype?
    if (this.mStashList[_itemIndex] !== null && _filter === this.mFilter1)
    {
        modURUI.showSlot(this.mInventoryModule.mInventorySlots[_itemIndex]);
        return;
    }

    if ((this.mStashList[_itemIndex] !== null) && (this.mStashList[_itemIndex].type & _filter) !== 0)   // filter and type have nothing in common
    {   // the item i exists and matches the filter:
        modURUI.showSlot(this.mInventoryModule.mInventorySlots[_itemIndex]);
    }
    else
    {   // the item i does not exist or it does not match the filter
        modURUI.hideSlot(this.mInventoryModule.mInventorySlots[_itemIndex]);
    }
}

// New helper function to apply a filter by hiding the Itemslot-Container
CharacterScreenDatasource.prototype.applyItemFilter = function(_filter, _scrollTop)
{
/*     console.error("this " + this);
    console.error("this.mInventorySlots " + this.mInventorySlots);
    console.error("this.isInStashMode " + this.isInStashMode()); */
    if (this.mInventoryModule === null) return;
    if (this.mInventoryModule.mInventorySlots === undefined) return;
    if (this.mInventoryModule.mInventorySlots === null) return;
    if (this.isInStashMode() === false) return;
    this.mCurrentFilter = _filter;  // Save the last applied filter so we can reapply it on reopening the screen
    for( var i = 0; i < this.mInventoryModule.mInventorySlots.length; i = ++i )
    {
        this.filterSingleItem(i, _filter);
    }
    if (_scrollTop) this.mInventoryModule.mListContainer.trigger('scroll', { element: this.mInventoryModule.mInventorySlots[0], scrollTo: 'top' });
}

// Overwrites of the vanilla filter notifies. We redirect them to apply the filtering locally
CharacterScreenDatasource.prototype.notifyBackendFilterAllButtonClicked = function()
{
    this.applyItemFilter(this.mFilter1, true);
};

CharacterScreenDatasource.prototype.notifyBackendFilterWeaponsButtonClicked = function()
{
    this.applyItemFilter(this.mFilter2, true);
};

CharacterScreenDatasource.prototype.notifyBackendFilterArmorButtonClicked = function()
{
    this.applyItemFilter(this.mFilter3, true);
};

CharacterScreenDatasource.prototype.notifyBackendFilterUsableButtonClicked = function()
{
    this.applyItemFilter(this.mFilter4, true);
};

CharacterScreenDatasource.prototype.notifyBackendFilterMiscButtonClicked = function()
{
    this.applyItemFilter(this.mFilter5, true);
};

// Manual forced update of the RosterWarning Icon that can be called from outside
CharacterScreenDatasource.prototype.setWarning = function(_data)
{
    // console.error("CharacterScreen setWarning hook");
    if (this.mFormationWarning !== _data[0])
    {
        this.mFormationWarning = _data[0];
        // This listener is important so that the Warning icon is immediately drawn
        this.notifyEventListener(CharacterScreenDatasourceIdentifier.Brother.SettingsChanged, _data[1]);  // I believe this causes a updateRosterLabel
    }
}
