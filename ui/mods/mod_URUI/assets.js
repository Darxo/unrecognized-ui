var modURUI = {
	// Global
	SHOW_EMPTY_SLOTS_CHARACTER_SCREEN:		true,
	SHOW_EMPTY_SLOTS_SHOP:					true,
	SLOT_SIZE:								null,

	// Const
	ID:											'mod_URUI',
	BUTTON_HIDE_EMPTY_SLOTS:					'ui/buttons/filter_hide_empty.png',
	BUTTON_SHOW_EMPTY_SLOTS:					'ui/buttons/filter_show_empty.png',
	BUTTON_TOGGLE_STATS_OVERLAYS_DAMAGED:		'ui/skin/icon_tabs_damaged.png',

	BUTTON_TOGGLE_HIGHLIGHT_BLOCKED_TILES_CUSTOM: 'ui/skin/icon_highlight_eye.png',    // For Highlight Blocked Tiles feature

	// Utility Functions
	hideSlot: function(_slot)
	{
		_slot.css('position', 'absolute');
		_slot.css('top', '-3000');

		// _slot.css('width', '0');
		// _slot.css('height', '0');

		_slot.css('pointer-events', 'none');
	},

	showSlot: function(_slot)
	{
		_slot.css('position', 'relative');
		_slot.css('top', '0');

		// _slot.css('width', modURUI.SLOT_SIZE);
		// _slot.css('height', modURUI.SLOT_SIZE);

		_slot.css('pointer-events', 'auto');
	}
}
