

// Utility Function that should be in MSU
::modURUI.GetValueAsHexString <- function(_array)	// Thanks to Taro for this
{
    local asArray = split(_array, ",");
    local red = format("%x", asArray[0].tointeger());
    local green = format("%x", asArray[1].tointeger());
    local blue = format("%x", asArray[2].tointeger());
    local opacity = format("%x", (asArray[3].tofloat() * 255).tointeger());
    if (red.len() == 1) red = "0" + red;
    if (green.len() == 1) green = "0" + green;
    if (blue.len() == 1) blue = "0" + blue;
    if (opacity.len() == 1) opacity = "0" + opacity;
    return  red + green + blue + opacity;
}

::modURUI.updateTopbarAssets <- function()
{
    if (::MSU.Utils.hasState("tactical_state")) return;
    if (::World.State.getPlayer() == null) return;  // We can't make an UI update if the player object doesnt exist yet
    ::World.State.updateTopbarAssets();
}
