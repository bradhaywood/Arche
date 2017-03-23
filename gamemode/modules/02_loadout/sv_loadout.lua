function GM:PlayerLoadout(ply)
	ply:Give("weapon_shotgun")
	ply:AllowFlashlight(true)

	return true
end