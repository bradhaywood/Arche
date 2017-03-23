AddCSLuaFile "shared.lua"
include "shared.lua"

Arche = Arche or {}

local moduleRoot = GM.FolderName .. "/gamemode/modules/"
local _, moduleFolders = file.Find(moduleRoot .. "*", "LUA")

table.sort(moduleFolders)

local function LoadSharedModules()
	for _, folder in pairs(moduleFolders) do
		local modpath = moduleRoot .. folder
		local files = file.Find(modpath .. "/*sh_*.lua", "LUA")
		for _, lfile in pairs(files) do
			ALog("[Arche] Loading Shared File: " .. lfile)
			AddCSLuaFile(modpath .. "/" .. lfile)
			include(modpath .. "/" .. lfile)
		end
	end
end

local function LoadServerModules()
	for _, folder in pairs(moduleFolders) do
		local modpath = moduleRoot .. folder
		local files = file.Find(modpath .. "/*sv_*.lua", "LUA")
		for _, lfile in pairs(files) do
			ALog("[Arche] Loading Server File: " .. lfile)
			include(modpath .. "/" .. lfile)
		end
	end
end

local function LoadClientModules()
	for _, folder in pairs(moduleFolders) do
		local modpath = moduleRoot .. folder
		local files = file.Find(modpath .. "/*cl_*.lua", "LUA")
		for _, lfile in pairs(files) do
			ALog("[Arche] Loading Client File: " .. lfile)
			AddCSLuaFile(modpath .. "/" .. lfile)
		end
	end
end

LoadSharedModules()
LoadServerModules()
LoadClientModules()

RunConsoleCommand("sv_allowcslua", "0");
RunConsoleCommand("mp_falldamage", "1");
RunConsoleCommand("sbox_godmode", "0");
RunConsoleCommand("sv_kickerrornum", "0");
RunConsoleCommand("sbox_playershurtplayers", "1");
