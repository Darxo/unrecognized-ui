# Description

 Collection of highly customizable UI-Features to improve quality of life. Includes an Overlay Bar rework and Itemfilter rework.

# List of all Changes

## Combat

### Overlay Bars

- Overlay Bars can be colored and scaled - You can assign different colors to allied vs. enemy overlay bars to better differentiate them during battle
- Add the option to only show Overlay Bars of entities which are damaged - the "damaged" threshold is customizable
- Each row of Mini-Icons now contain up to 5 Icons (up from 4)
- You can customize the duration that an Overlay Bar is highlighted when an entity takes damage
- Mini Icons can be made partly or fully transparent
- Remove the mini helmet, -chest and -health icons on the bars

### Blocked Tiles

- Add a new third highlighting option for tiles which are blocked
  - Tiles which block vision then have a new overlay image with an eye on it to differentiate them from tiles which only block movement
- The last chosen highlight option for tiles is now remembered throughout the whole playthrough

### Round Information

- Add two new settings for changing how the ally number and enemy numbers are displayed
- You can now change the ally number to tell exactly how many brothers vs. non-brother allies are on the battlefield.
  - **12 Brothers**, which unleashed **3 dogs** and fight alongside a **4 character caravan** will now display like this: `12 + 7`
- You can now change the enemy number to tell exactly how many enemies are currently visible to you compared to how many are present in total
  - If you **can see only 4** of your **opposing 15 enemies** then the enemy counter will now display: `4 (15)`

## World

### Global Mood Icon

- Add Setting to display a mood icon on top of the roster button while on the world screen or town screen
- You can either make this display the lowest mood currently on your brothers or the average mood

## Character Screen / Inventory

### Item Filter

- Switching between Item Filter no longer has any delay
- Add a new button in the inventory which hides all empty item slots, when toggled
- The active item filter now has a green border around it
- Add hotkeys for switching between the item filter. By default that is: 1 - 5
- Shields are now moved to the Weapon-Filter (was previously part of the Armor-Filter)
- Item Filter can optionally also apply to the shop

### Damaged Health/Armor Indicator

- You can now customize the threshold at which the Missing-Health icon is displayed on your brothers
- Missing Armor on a brother will now also display an icon over a brother
- You can customize the threshold at which the Missing-Armor icon is displayed on your brothers

### Display Base Fatigue/Initiative

- Add an option in the menu to display the base stamina and base intiative of a character in the stats section of the character screen outside of battle
- When activated those progressbars will no longer be always empty. They will now display the current Stat as the colored part and the Base Stat as its maximum.

## Misc

### Generate Mod List

- Add a new button in the mod settings that provides a list with the names of all mods currently registered

# Requirements

- [Modern Hooks](https://www.nexusmods.com/battlebrothers/mods/685)
- [MSU](https://www.nexusmods.com/battlebrothers/mods/479)

# Known Issues:

# Compatibility

- Is safe to remove from- and add to any existing savegames

## Compatible with:

- [Legends](https://www.nexusmods.com/battlebrothers/mods/60), [EIMO](https://www.nexusmods.com/battlebrothers/mods/239), Reforged
- If used with [Armour Indicators](https://www.nexusmods.com/battlebrothers/mods/96), make sure to turn the Thresholds for showing Armor indicators all the way to 0 in the settings

## Not Compatible with:

- [Undress](https://www.nexusmods.com/battlebrothers/mods/338)

