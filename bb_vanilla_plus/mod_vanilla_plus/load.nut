// ::include("mod_crock_pot/some_priority_script");	// This file needs priority

// API Hooks
::includeFiles(::IO.enumerateFiles("mod_vanilla_plus/api/namespaces"));
::includeFiles(::IO.enumerateFiles("mod_vanilla_plus/api/hooks"));

// Regular Hooks
::includeFiles(::IO.enumerateFiles("mod_vanilla_plus/hooks"));

::Hooks.registerJS("ui/mods/setup.js");