// custom class that controls the display of overlay bars and overlay mini icons on top of an actor
this.custom_overlay_bars <- {
	m = {
	// Set during init
		Actor = null,               // Actor object that this overlay is attached to
		HelmetBar = null,           // helmet armor bar sprite
		ChestBar = null,            // chest armor bar sprite
		HitpointBar = null,         // hitpoints bar sprite
		BackgroundBars = null,      // backgroudn bars sprite
		OverlayMiniIcons = [],      // Array with the size of this.m.IconsMax that is generated once for every character and then updated

	// Saved inbetween different function calls
		CurrentVerticalOffset = 0,
		HeadArmor = 0.0,
		BodyArmor = 0.0,
		Health = 0.0,
		IsVisible = false,          // An overlay that is invisible ignores most updates to save performance
		DisplayedMiniIcons = 0,     // amount of miniIcons that are currently displayed
		// Colors are saved here so they don't need to be read out of the mod settings every time is applied. Because changing the brush/bar length removes the old color
		HelmetColor = null,
		ChestColor = null,
		AllyHealthColor = null,
		EnemyHealthColor = null,

	// Async-Counter
		IsForceDisplaying = 0,  // Are we force displaying this Overlay regardless of the display?  Usually this is 1 at most. But an entity is hit multiple times quickly then this can be higher

	// Config
		IconsPerRow = 5,    // Changing this doesn't affect the size of the icons so the gaps between them will just be bigger/smaller
		IconsMax = 30,      // Arbitruary maximum. Icons beyond that are just not shown

	// Const
		BackgroundBarAlpha = 200,   // I don't offer a way to customize the Alpha of the background bars. The compromise is that I let them start a bit more transparent than in Vanilla
		SizeOfIcon = 20,    // Only influences position and therefor gaps between Icons. Not their actual size
		IconStartingHeight = 110,
		BarsStartingHeight = 90,
		IconSpriteName = "MDN_OverlayMiniIcon_",    // prefix for mini icon sprite names
		OverlayBarBrushes = [                       // 24 different sizes of bars to display all the values that you hopefully need
			"MDN_entityoverlay_bar_1",
			"MDN_entityoverlay_bar_2",
			"MDN_entityoverlay_bar_3",
			"MDN_entityoverlay_bar_4",
			"MDN_entityoverlay_bar_5",
			"MDN_entityoverlay_bar_6",
			"MDN_entityoverlay_bar_7",
			"MDN_entityoverlay_bar_8",
			"MDN_entityoverlay_bar_9",
			"MDN_entityoverlay_bar_10",
			"MDN_entityoverlay_bar_11",
			"MDN_entityoverlay_bar_12",
			"MDN_entityoverlay_bar_13",
			"MDN_entityoverlay_bar_14",
			"MDN_entityoverlay_bar_15",
			"MDN_entityoverlay_bar_16",
			"MDN_entityoverlay_bar_17",
			"MDN_entityoverlay_bar_18",
			"MDN_entityoverlay_bar_19",
			"MDN_entityoverlay_bar_20",
			"MDN_entityoverlay_bar_21",
			"MDN_entityoverlay_bar_22",
			"MDN_entityoverlay_bar_23",
			"MDN_entityoverlay_bar_24"
		]
	},

	function init( _actor )
	{
		this.m.Actor = ::MSU.asWeakTableRef(_actor);

		this.m.BackgroundBars = _actor.addSprite("MDN_BackgroundBars");
		this.m.BackgroundBars.setBrush("MDN_entityoverlay_bottom");
		this.m.BackgroundBars.Alpha = this.m.BackgroundBarAlpha;
		_actor.setSpriteRenderToTexture("MDN_BackgroundBars", false);

		this.m.HelmetBar = _actor.addSprite("MDN_HelmetBar");
		this.m.HelmetBar.setBrush("MDN_entityoverlay_bar_24");
		_actor.setSpriteRenderToTexture("MDN_HelmetBar", false);

		this.m.ChestBar = _actor.addSprite("MDN_ChestBar");
		this.m.ChestBar.setBrush("MDN_entityoverlay_bar_24");
		_actor.setSpriteRenderToTexture("MDN_ChestBar", false);

		this.m.HitpointBar = _actor.addSprite("MDN_HitpointBar");
		this.m.HitpointBar.setBrush("MDN_entityoverlay_bar_24");
		_actor.setSpriteRenderToTexture("MDN_HitpointBar", false);

		for(local i = 0; i < this.m.IconsMax ; i++)
		{
			this.m.OverlayMiniIcons.push(_actor.addSprite(this.m.IconSpriteName + i));
			_actor.setSpriteRenderToTexture(this.m.IconSpriteName + i, false);
		}
	}

	// Do a simple check for the visibility of the bars.
	function setDirty(_bool = true)
	{
		if (this.m.Actor.isPlacedOnMap() == false) return;
		this.checkVisibility();    // this currently includes a updateColors()
	}

	// Also updates properties that can only change from mod settings
	function fullUIUpdate()
	{
		if (this.m.Actor.isPlacedOnMap() == false) return;
		this.m.HelmetColor = ::createColor(::modURUI.Mod.ModSettings.getSetting("ChestBarColor").getValueAsHexString());
		this.m.ChestColor = ::createColor(::modURUI.Mod.ModSettings.getSetting("HelmetBarColor").getValueAsHexString());
		this.m.AllyHealthColor = ::createColor(::modURUI.Mod.ModSettings.getSetting("AllyHealthBarColor").getValueAsHexString());
		this.m.EnemyHealthColor = ::createColor(::modURUI.Mod.ModSettings.getSetting("EnemyHealthBarColor").getValueAsHexString());

		local newScale = ::modURUI.Mod.ModSettings.getSetting("OverlaySize").getValue();
		this.m.CurrentVerticalOffset = ::modURUI.Mod.ModSettings.getSetting("VerticalOffset").getValue();
		this.updateOverlayPosition();
		this.scaleOverlay(newScale / 100.0);
		this.checkVisibility(true);
	}

	// This is being called a lot of times (~35) from 'World::onCombatFinished'. So keep that in mind future-me!
	function setOverlayValues( _headArmor, _bodyArmor, _hitpoints )   // These values are usually between 0.0 and 1.0. Unless some mod does glitchy things again
	{
		if (!::MSU.Utils.hasState("tactical_state")) return;    // This gets probably called all the time when bros gain armor/health on world map

		if (_headArmor == this.m.HeadArmor && _bodyArmor == this.m.BodyArmor && _hitpoints == this.m.Health) return;    // Nothing has changed
		// Save current values so we can compare against them in order to save performance
		this.m.HeadArmor = _headArmor;
		this.m.BodyArmor = _bodyArmor;
		this.m.Health = _hitpoints;

		this.m.HelmetBar.setBrush(this.translateToBar(_headArmor));
		this.m.ChestBar.setBrush(this.translateToBar(_bodyArmor));
		this.m.HitpointBar.setBrush(this.translateToBar(_hitpoints));
		this.updateOverlayBarPositions();   // Setting new brush always resets the position of those sprites
		this.updateColors()                 // Setting new brush always resets the color of those sprites

		// Now we check whether we force the overlay to display because the health or armor on it just changed
		if (::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue() == ::modURUI.COB.AlwaysShow.Setting) return;
		if (_hitpoints == 0.0) return;
		local forceDisplayDuration = ::modURUI.Mod.ModSettings.getSetting("ForceDisplayDuration").getValue();
		if (forceDisplayDuration == 0) return;

		this.forceDisplayOverlay(forceDisplayDuration * 1000);
	}

	// Decides whether the Overlay should be visible
	function checkVisibility( _forceUpdate = false )
	{
		if (this.m.IsForceDisplaying != 0)
		{
			this.setVisible(true, _forceUpdate);
			return;
		}

		local displayMode = ::modURUI.Mod.ModSettings.getSetting("OverlayDisplayMode").getValue();
		if      (displayMode == ::modURUI.COB.AlwaysShow.Setting)           this.setVisible(true, _forceUpdate);
		else if (displayMode == ::modURUI.COB.NeverShow.Setting)            this.setVisible(false, _forceUpdate);
		else if (displayMode == ::modURUI.COB.OnlyWhileDamaged.Setting)
		{
			local skinCountsAsUnDamaged = ::modURUI.Mod.ModSettings.getSetting("SkinCountsAsUnDamaged").getValue();
			local armorThreshold        = ::modURUI.Mod.ModSettings.getSetting("OverlayArmorThreshold").getValue() / 100.0;
			local healthThreshold       = ::modURUI.Mod.ModSettings.getSetting("OverlayHealthThreshold").getValue() / 100.0;
			if (((this.m.HeadArmor >= armorThreshold) && (this.m.BodyArmor >= armorThreshold) && (this.m.Health >= healthThreshold))    // either all current values pass the thresholds
				|| (skinCountsAsUnDamaged && this.m.Health == 1.0 && (this.m.HeadArmor + this.m.BodyArmor) == 0.0))                     // or we have an enemy with "just skin"
			{
				this.setVisible(false, _forceUpdate);
			}
			else
			{
				this.setVisible(true, _forceUpdate);
			}
		}
	}

	// Actually applies the effects of the current state of visibility
	function updateVisibility()
	{
		this.setOverlayBarVisibility(this.isVisible());
		this.setIconVisibility(this.isVisible());
		this.updateColors();
	}

	// Updates the sprite colors from the last saved color values
	function updateColors()
	{
		if (this.m.HelmetColor == null) return;     // Simple check to prevent assigning null as colors when a fullUIUpdate hasnt happened yet
		this.m.ChestBar.Color = this.m.ChestColor;
		this.m.HelmetBar.Color = this.m.HelmetColor;

		if (this.m.Actor.isAlliedWithPlayer())
		{
			this.m.HitpointBar.Color = this.m.AllyHealthColor;
		}
		else
		{
			this.m.HitpointBar.Color = this.m.EnemyHealthColor;
		}
	}

	function translateToBar( _float )
	{
		if (_float == 0.0) return "";   // Only 0 value should hide the bar completely. Any other value, even 0.001 should display the smallest piece
		_float = ::Math.minf(1.0, ::Math.maxf(0.0, _float));
		return this.m.OverlayBarBrushes[::Math.floor(_float * (this.m.OverlayBarBrushes.len() - 1))];
	}

	function setOverlayBarVisibility(_visible)
	{
		this.m.HelmetBar.Visible = _visible;
		this.m.ChestBar.Visible = _visible;
		this.m.HitpointBar.Visible = _visible;
		this.m.BackgroundBars.Visible = _visible;
	}

	function setIconVisibility(_visible)
	{
		local miniIconAlpha = ::modURUI.Mod.ModSettings.getSetting("IconAlpha").getValue();
		foreach(sprite in this.m.OverlayMiniIcons)
		{
			sprite.Visible = _visible;
			sprite.Alpha = miniIconAlpha;
		}
	}

	function updateOverlayPosition()
	{
		this.m.BackgroundBars.setOffset(::createVec(0, this.m.BarsStartingHeight + this.m.CurrentVerticalOffset));

		this.updateOverlayBarPositions();
		this.updateOverlayIconPositions();
	}

	function updateOverlayBarPositions()
	{
		local vectorPosition = ::createVec(0, this.m.BarsStartingHeight + this.m.CurrentVerticalOffset);
		this.m.HelmetBar.setOffset(vectorPosition);
		this.m.ChestBar.setOffset(::createVec(vectorPosition.X, vectorPosition.Y - 7));
		this.m.HitpointBar.setOffset(::createVec(vectorPosition.X, vectorPosition.Y - 14));
	}

	function updateOverlayIconPositions()
	{
		local startingPosition = ::createVec((-(this.m.IconsPerRow - 1) * this.m.SizeOfIcon / 2.0), this.m.IconStartingHeight + this.m.CurrentVerticalOffset);
		local currentPosition = ::createVec(startingPosition.X, startingPosition.Y);

		local placedIcons = 0;
		foreach(sprite in this.m.OverlayMiniIcons)
		{
			sprite.setOffset(currentPosition);
			placedIcons++;
			currentPosition.X += this.m.SizeOfIcon;
			if (placedIcons % this.m.IconsPerRow == 0)
			{
				currentPosition.X = startingPosition.X;
				currentPosition.Y += this.m.SizeOfIcon;
			}
		}
	}

	// For each Icon passed: its brush is drawn on one of the Icon-Positions on top of the overlay bars
	function setOverlayIcons(_iconArray)
	{
		local startingPosition = ::createVec((-(this.m.IconsPerRow - 1) * this.m.SizeOfIcon / 2.0), this.m.IconStartingHeight + this.m.CurrentVerticalOffset);
		local currentPosition = ::createVec(startingPosition.X, startingPosition.Y);

		local placedIcons = 0;  // because we use module operator we dont't want this to start at 0
		foreach(iconSprite in _iconArray)
		{
			this.m.OverlayMiniIcons[placedIcons].setBrush(iconSprite);
			this.m.OverlayMiniIcons[placedIcons].setOffset(currentPosition);
			placedIcons++
			currentPosition.X += this.m.SizeOfIcon;
			if (placedIcons % this.m.IconsPerRow == 0)
			{
				currentPosition.X = startingPosition.X;
				currentPosition.Y += this.m.SizeOfIcon;
			}
			if (placedIcons >= this.m.IconsMax) break;
		}
		for(; placedIcons < this.m.IconsMax ; placedIcons++)    // Todo: do performance improvements
		{
			this.m.OverlayMiniIcons[placedIcons].resetBrush();
		}
	}

	function scaleOverlay( _size )
	{
		this.m.BackgroundBars.Scale = _size;
		this.m.HelmetBar.Scale = _size;
		this.m.ChestBar.Scale = _size;
		this.m.HitpointBar.Scale = _size;
		this.m.BackgroundBars.Alpha = this.m.BackgroundBarAlpha;    // Otherwise this sprite will somehow lose its one-time alpha value. Idk why.
		foreach(sprite in this.m.OverlayMiniIcons)
		{
			sprite.Scale = _size;
		}
	}

	function isVisible()
	{
		return this.m.IsVisible;
	}

	function setVisible( _visible, _forceUpdate = false )
	{
		if (this.m.IsVisible == _visible && _forceUpdate == false) return;      // To save performance
		this.m.IsVisible = _visible;
		this.updateVisibility();
	}

// Async Features
	function reset()    // I call this at the onCombatStarted of all player entities
	{
		this.m.IsForceDisplaying = 0;
	}

	// Forces the overlay to be displayed for _visibleFor milliseconds.
	function forceDisplayOverlay(_visibleFor)
	{
		this.m.IsForceDisplaying++;
		this.checkVisibility(true);     // true is probably not needed. But shouldnt matter much performance wise

		::Time.scheduleEvent(::TimeUnit.Real, _visibleFor, this.decrementIsForceDisplaying.bindenv(this), {});
	}

	function decrementIsForceDisplaying( _data )    // a scheduleEvent function is required to have one parameter even if I don't use it
	{
		if (this == null) return;
		this.m.IsForceDisplaying--;
		if (this.m.IsForceDisplaying < 0) this.m.IsForceDisplaying = 0;
		if (::MSU.isNull(this.m.Actor)) return;     // Midas told me to use this
		if (this.m.Actor.isAlive() == false) return;
		if (this.m.Actor.isPlacedOnMap() == false) return;

		this.checkVisibility();
	}

	// Hacky solution to negate the sideeffects of the vanilla fadeToStoredColors function. Otherwise my sprites would return to their default color
	function negateFade(_data = null)
	{
		if (this.m.HitpointBar.Fading == false)
		{
			::Time.scheduleEvent(::TimeUnit.Real, 50, this.asyncFullUIUpdate.bindenv(this), {});
			return;
		}
		::Time.scheduleEvent(::TimeUnit.Real, 50, this.negateFade.bindenv(this), {});
	}

	function asyncFullUIUpdate( _data )         // a scheduleEvent function is required to have one parameter even if I don't use it
	{
		this.fullUIUpdate();
	}

};
