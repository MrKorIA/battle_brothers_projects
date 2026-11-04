// Namespace for generic global utility functions
::VanillaPlus.Util <- {};

::VanillaPlus.Util.ScriptReplacementTable <- {};

::VanillaPlus.Util.registerReplacementScript <- function( _oldScript, _newScript )
{
	::VanillaPlus.Util.ScriptReplacementTable[_oldScript] <- _newScript;
}
