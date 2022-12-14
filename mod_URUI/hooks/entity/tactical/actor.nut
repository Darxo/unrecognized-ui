::mods_hookExactClass("entity/tactical/actor", function(o) {
    o.m.CustomOverlayBars <- null;

    // We use this so that our Overlay Bar Sprites are created last and drawn over everthing else
    local oldOnAfterInit = o.onAfterInit;
    o.onAfterInit = function()
    {
        oldOnAfterInit();
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
    local oldUpdateOverlay = o.updateOverlay;
    o.updateOverlay = function()
    {
        // oldUpdateOverlay();  // We don't call this because we completely emulate the old behavior now

		if (!this.isAlive()) return;
        if (this.getCustomOverlayBars() == null) return;

        // For some reason the updateOverlay is called for each and every entity at all times. Because somehow the setDirty() of every entity ever is permanently called
        // This is to increase performance
        if (!::MSU.Utils.hasState("tactical_state")) return;

        this.getCustomOverlayBars().setOverlayIcons(this.getOverlayIcons());        // Maybe save performance here? Updating the overlay Icons every time may be tedious

        // Overlay Bars
		local headArmor = 0.0;
		local bodyArmor = 0.0;
		if (this.getArmorMax(this.Const.BodyPart.Head) > 0)
		{
			headArmor = this.getArmor(this.Const.BodyPart.Head) / this.getArmorMax(this.Const.BodyPart.Head);
		}
		if (this.getArmorMax(this.Const.BodyPart.Body) > 0)
		{
			bodyArmor = this.getArmor(this.Const.BodyPart.Body) / this.getArmorMax(this.Const.BodyPart.Body);
		}

        // These values are usually between 0.0 and 1.0. Unless some mod does glitchy things again
        this.getCustomOverlayBars().setOverlayValues(headArmor, bodyArmor, this.getHitpoints() / this.getHitpointsMax());

        this.getCustomOverlayBars().setDirty();
    }

    // Properties like the HP bar color can only be applied correctly once they are placed and therefor assigned a faction.
    // Since that doesn't happen during the `onPlacedOnMap` function we have to hook the next best function in line:
    local oldOnPlacedOnMap = o.onPlacedOnMap;
    o.onPlacedOnMap = function()
    {
        oldOnPlacedOnMap();
        if (this.getFaction() == 1)  // Only brothers have a factionID at this point and that is 1 so they can be initialised at this point already
        {
            this.getCustomOverlayBars().fullUIUpdate();
        }
    }

    // Properties like the HP bar color can only be applied correctly once they are placed and therefor assigned a faction.
    // Since that doesn't happen during the `onPlacedOnMap` function we have to hook the next best function in line:
    local oldSetFaction = o.setFaction;
    o.setFaction = function( _newFaction )
    {
        local factionChanged = (this.getFaction() != _newFaction);
        oldSetFaction(_newFaction);
        if (factionChanged && this.getCustomOverlayBars() != null)  // The game changes the faction somewhere before the onAfterInit where the overlay is initialised
        {
            this.getCustomOverlayBars().fullUIUpdate();
        }
    }

    // new functions
    o.getCustomOverlayBars <- function ()
    {
        return this.m.CustomOverlayBars;
    }

    o.getOverlayIcons <- function()
    {
        local status = this.getSkills().query(::Const.SkillType.StatusEffect | ::Const.SkillType.Terrain);
		local icons = [];
		foreach( s in status )
		{
			if (s.getIconMini().len() != 0)
			{
				icons.push(s.getIconMini());
			}
		}
        return icons;
    }
});
