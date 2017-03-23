include "shared.lua"

local moduleRoot = GM.FolderName .. "/gamemode/modules/"
local _, moduleFolders = file.Find(moduleRoot .. "*", "LUA")

table.sort(moduleFolders)

local function LoadSharedModules()
	for _, folder in pairs(moduleFolders) do
		local modpath = moduleRoot .. folder
		local files = file.Find(modpath .. "/*sh_*.lua", "LUA")
		for _, lfile in pairs(files) do
			include(modpath .. "/" .. lfile)
		end
	end
end

local function LoadClientModules()
	for _, folder in pairs(moduleFolders) do
		local modpath = moduleRoot .. folder
		local files = file.Find(modpath .. "/*cl_*.lua", "LUA")
		for _, lfile in pairs(files) do
			include(modpath .. "/" .. lfile)
		end
	end
end

LoadSharedModules()
LoadClientModules()