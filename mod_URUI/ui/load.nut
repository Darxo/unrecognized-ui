::mods_registerJS("mod_URUI/assets.js");

local prefixLen = "ui/mods/".len();
foreach (file in ::IO.enumerateFiles("ui/mods/mod_URUI/js_hooks"))
{
	::mods_registerJS(file.slice(prefixLen) + ".js");
}

local prefixLen = "ui/mods/".len();
foreach (file in ::IO.enumerateFiles("ui/mods/mod_URUI/css_hooks"))
{
	::mods_registerCSS(file.slice(prefixLen) + ".css");
}
