::modURUI.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	q.m.CustomOverlayBars <- null;
	q.m.WasUpdateVisibilityHooked <- false;

	// We use this so that our Overlay Bar Sprites are created last and drawn over everthing else
	q.onAfterInit = @(__original) function()
	{
		__original();
		this.m.CustomOverlayBars = ::new("mod_URUI/class/custom_overlay_bars");
		this.m.CustomOverlayBars.init(this);

	/*
		fadeToStoredColors is one of those functions that is given to actor between create and init.
		It apparently tries to return the color of all sprites to the previously saved value.
		However for some reason it is not able to return the color of my CustomOverlayBars-related sprites and instead turns them white.
		This is caused by the legends Demon_Hound and presumably by all enemies that teleport when being hit

		I don't know how to prevent it from fading my sprites.
		So my best solution is to run my own function alongside which turns the colors back to normal the moment that the fading is done.
		This will still look a bit weird.
	*/

		// Necrosavants teleporting inside bushes become invisible. Maybe this is the cause?
		local oldFadeToStoredColors = ::mods_getMember(this, "fadeToStoredColors");
		mods_override(this, "fadeToStoredColors", function(_duration = 0)   // I've got a 'wrong number of parameters' error after necrosavant used darkflight. So maybe they needed less/more parameter? thats why I set this to = 0
		{
			oldFadeToStoredColors(_duration);
			this.getCustomOverlayBars().negateFade();
		});
	}

	// This is called whenever the setDirty of the entity is called
	q.updateOverlay = @() function()	// We overwrite the vanilla function because we completely emulate that behavior now
	{
		if (!this.isAlive()) return;
		if (this.getCustomOverlayBars() == null) return;

		// For some reason the updateOverlay is called for each and every entity at all times. Because somehow the setDirty() of every entity ever is permanently called
		// This is to increase performance
		if (!::MSU.Utils.hasState("tactical_state")) return;

		this.getCustomOverlayBars().setOverlayIcons(this.getOverlayIcons());        // Maybe save performance here? Updating the overlay Icons every time may be tedious

		// Overlay Bars
		local headArmor = 0.0;
		local bodyArmor = 0.0;
		if (this.getArmorMax(::Const.BodyPart.Head) > 0)
		{
			headArmor = this.getArmor(::Const.BodyPart.Head) / this.getArmorMax(::Const.BodyPart.Head);
		}
		if (this.getArmorMax(::Const.BodyPart.Body) > 0)
		{
			bodyArmor = this.getArmor(::Const.BodyPart.Body) / this.getArmorMax(::Const.BodyPart.Body);
		}

		// These values are usually between 0.0 and 1.0. Unless some mod does glitchy things again
		this.getCustomOverlayBars().setOverlayValues(headArmor, bodyArmor, this.getHitpoints() / this.getHitpointsMax());

		this.getCustomOverlayBars().setDirty();
	}

	// Properties like the HP bar color can only be applied correctly once they are placed and therefor assigned a faction.
	// Since that doesn't happen during the `onPlacedOnMap` function we have to hook the next best function in line:
	q.onPlacedOnMap = @(__original) function()
	{
		__original();
		if (this.getFaction() == 1)  // Only brothers have a factionID at this point and that is 1 so they can be initialised at this point already
		{
			this.getCustomOverlayBars().fullUIUpdate();
		}
	}

	// Properties like the HP bar color can only be applied correctly once they are placed and therefor assigned a faction.
	// Since that doesn't happen during the `onPlacedOnMap` function we have to hook the next best function in line:
	q.setFaction = @(__original) function( _newFaction )
	{
		local factionChanged = (this.getFaction() != _newFaction);
		__original(_newFaction);
		if (factionChanged && this.getCustomOverlayBars() != null)  // The game changes the faction somewhere before the onAfterInit where the overlay is initialised
		{
			this.getCustomOverlayBars().fullUIUpdate();
		}
	}

	q.onPlacedOnMap = @(__original) function()
	{
		__original();

		if (!this.m.WasUpdateVisibilityHooked)	// Otherwise player characters and other actors which persist between fights, would be hooked multiple times here
		{
			this.m.WasUpdateVisibilityHooked = true;

			// The function updateVisibility is added to entities on-the-fly at some point after initialization. That's why we can only hook it here
			local oldUpdateVisibility = this.entity.updateVisibility;
			this.entity.updateVisibility = function( _tile, _visionRadius, _faction )
			{
				oldUpdateVisibility(_tile, _visionRadius, _faction);

				if (_faction == ::Const.Faction.Player)
				{
					::Tactical.TopbarRoundInformation.refreshTopbarIfChanged();
				}
			}
		}
	}

// New Functions
	q.getCustomOverlayBars <- function ()
	{
		return this.m.CustomOverlayBars;
	}

	q.getOverlayIcons <- function()
	{
		local status = this.getSkills().query(::Const.SkillType.StatusEffect | ::Const.SkillType.Terrain);
		local icons = [];
		foreach (s in status)
		{
			if (s.getIconMini().len() != 0)
			{
				icons.push(s.getIconMini());
			}
		}
		return icons;
	}
});
