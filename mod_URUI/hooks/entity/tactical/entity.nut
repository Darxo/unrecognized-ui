// We need this hook because we want assign custom sprite after most/all other initialisations are done
::mods_hookDescendants("entity/tactical/entity", function(o)
{
// Highlight Blocked Tiles
    if ("onInit" in o)
    {
        local oldOnInit = o.onInit;
        o.onInit = function()
        {
            oldOnInit();
            ::modURUI.HBT.generateSingleOverlay(this);
        }
    }
});
