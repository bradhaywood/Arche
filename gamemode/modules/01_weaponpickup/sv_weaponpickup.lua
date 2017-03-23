// Script by Sofi
// sofi.pink

CreateConVar("sv_manualweaponpickup", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Is manual weapon pickup enabled?")
CreateConVar("sv_manualweaponpickup_aim", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Must the player be aiming at the weapon?")
CreateConVar("sv_manualweaponpickup_auto", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Holding use key picks up weapons automatically.")
CreateConVar("sv_manualweaponpickup_autodraw", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Player will automatically draw a given weapon.")
CreateConVar("sv_manualweaponpickup_weaponlimit", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "How many weapons a player can hold at once.  (0 = No Limit)")
CreateConVar("sv_manualweaponpickup_weaponlimitswap", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Drop current weapon to pick up another if player is holding too many.")

local plmeta = FindMetaTable("Player")

function plmeta:Give(classname)
	local ent = ents.Create(classname)
	if (!IsValid(ent)) then return end
	ent:SetPos(self:GetPos())
	ent.GiveTo = self
	ent:Spawn()

	if (GetConVar("sv_manualweaponpickup_autodraw"):GetBool()) then
		timer.Simple(0.1, function() self:SelectWeapon(classname) end)
	end
end

plmeta._DropWeapon = plmeta.DropWeapon

function plmeta:DropWeapon(weapon)
	if (IsValid(weapon)) then
		self:_DropWeapon(weapon)
		weapon.GiveTo = nil
	end
end

local function canCarryWeapon(pl, weapon)
	local limit = GetConVar("sv_manualweaponpickup_weaponlimit"):GetInt()
	if (limit != 0 && #pl:GetWeapons() >= limit) then
		if (GetConVar("sv_manualweaponpickup_weaponlimitswap"):GetBool()) then
			if (pl.PressedUse) then
				pl.PressedUse = false
				pl:DropWeapon(pl:GetActiveWeapon())
				pl.DrawWeapon = weapon:GetClass()
				timer.Simple(0.1, function() pl:SelectWeapon(pl.DrawWeapon) end)
				return true
			end
		end
		return false
	end
	return true
end

hook.Add("PlayerCanPickupWeapon", "ManualWeaponPickup_CanPickup", function(pl, ent)
	
	if (pl.ManualWeaponPickupSpawn) then
		if (CurTime() > pl.ManualWeaponPickupSpawn) then
			if (IsValid(ent.GiveTo)) then
				if (ent.GiveTo == pl) then
					return true
				end
			end
			if (GetConVar("sv_manualweaponpickup"):GetBool()) then
				if (pl:KeyDown(IN_USE)) then
					if (GetConVar("sv_manualweaponpickup_aim"):GetBool()) then
						if (pl:GetEyeTrace().Entity == ent) then
							if (!GetConVar("sv_manualweaponpickup_auto"):GetBool()) then
								if (pl.PressedUse) then
									local c = canCarryWeapon(pl, ent)
									pl.PressedUse = false
									return c
								else
									return false
								end
							else
								return canCarryWeapon(pl, ent)
							end
						else
							return false
						end
					else
						if (!GetConVar("sv_manualweaponpickup_auto"):GetBool()) then
							if (pl.PressedUse) then
								pl.PressedUse = false
								return canCarryWeapon(pl, ent)
							else
								return false
							end
						else
							return canCarryWeapon(pl, ent)
						end
					end
				else
					return false
				end
			end
		end
	end
end)

hook.Add("KeyPress", "ManualWeaponPickup_KeyPress", function(pl, key)
	if (key == IN_USE) then
		pl.PressedUse = true
	end
end)

hook.Add("PlayerSpawn", "ManualWeaponPickup_PlayerSpawn", function(pl)
	pl.ManualWeaponPickupSpawn = CurTime()
end)

concommand.Add("dropweapon", function(pl)
	pl:DropWeapon(pl:GetActiveWeapon())
end)

// sofi.pink